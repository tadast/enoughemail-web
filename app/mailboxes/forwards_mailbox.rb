class ForwardsMailbox < ApplicationMailbox
  # Callbacks specify prerequisites to processing
  before_processing :check_if_client, :check_if_valid_block

  def process
    email_pattern = if intends_to_block_domain?
      "*@#{email_address_domain_to_block}"
    else
      email_address_to_block
    end

    filter_rule = forwarder.filter_rules.create!(
      organization: forwarder.organization,
      email_pattern: email_pattern,
      scope: intends_to_block_for_everyone? ? :for_everyone : :for_individual,
      source: :email
    )

    FilterRuleApplicationJob.perform_later(filter_rule: filter_rule)
  end

  private

  def email_address_to_block
    # TODO would this work for non-english UI?
    # IDEA: when email address to block can not be extracted reliably, respond with an email that has links with a list of all blockable emails
    # mail.body.raw_source[/From: .*<(.*?)>/, 1]
    mail.body.decoded.lines.map(&:strip).join[/From: .*?<(.+?@.+?)>/, 1]
  end

  def email_address_domain_to_block
    domain = email_address_to_block.split("@").last.to_s
    raise "invalid domain: #{domain}" unless domain.to_s.size > 4 && domain.include?(".")

    domain
  end

  def check_if_client
    if forwarder.nil? || forwarder.organization.nil?
      inbound_email.bounced!
      # TODO: bounce_with Forwards::BounceMailer.not_a_client(inbound_email, forwarder: forwarder)
    end
  end

  def check_if_valid_block
    if intends_to_block_domain? && EmailDomain.new(email_address_domain_to_block).common?
      inbound_email.bounced!
      # TODO: bounce_with Forwards::BounceMailer.common_email_domain(inbound_email, forwarder: forwarder)
    end

    if email_address_domain_to_block == forwarder.organization&.domain
      inbound_email.bounced!
      # TODO: bounce_with Forwards::BounceMailer.self_own(inbound_email, forwarder: forwarder)
    end
  end

  def intends_to_block_domain?
    mail_to_address.match?(/domain/)
  end

  def intends_to_block_for_everyone?
    mail_to_address.match?(/everybody/) || mail_to_address.match?(/everyone/)
  end

  def forwarder
    # TODO: check for spoofing?
    @forwarder ||= User.find_by(email: mail.from.first.downcase)
  end

  def mail_to_address
    @mail_to_address ||= mail.to.find { |address| address.to_s.include?("@had.enoughemail.com") }
  end
end
