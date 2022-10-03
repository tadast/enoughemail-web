class ForwardsMailbox < ApplicationMailbox
  # Callbacks specify prerequisites to processing
  before_processing :check_if_client, :check_if_valid_block

  def process
    # Record the forward on the one project, or…
    target_email = email_address_to_block

    mail_to = mail.to.first
    email_pattern = if mail_to.match?(/block/) && mail_to.match?(/domain/)
      domain = target_email.split("@").last.to_s
      raise "invalid domain: #{domain}" unless domain.to_s.size > 4 && domain.include?(".")

      "*@#{domain}"
    elsif mail_to.match?(/block/)
      target_email
    end

    filter_rule = forwarder.filter_rules.create!(
      organization: forwarder.organization,
      email_pattern: email_pattern,
      scope: :for_everyone, # TODO: add ability to block for self only v.s. the whole org
      source: :email
    )
    filter_rule.apply_to_google!
  end

  private

  def email_address_to_block
    # TODO would this work for non-english UI?
    # IDEA: when email address to block can not be extracted reliably, respond with an email that has links with a list of all blockable emails
    mail.body.raw_source[/From: .*<(.*?)>/, 1]
  end

  def check_if_client
    if forwarder.nil?
      # Use Action Mailers to bounce incoming emails back to sender – this halts processing
      inbound_email.bounced!
      # bounce_with Forwards::BounceMailer.not_a_client(inbound_email, forwarder: forwarder)
    end
  end

  def check_if_valid_block
    # target = email_address_to_block
    # bounce if trying to block a common domain or own organisation
  end

  def forwarder
    # TODO: check for spoofing
    @forwarder ||= User.find_by(email: mail.from.first.downcase)
  end
end
