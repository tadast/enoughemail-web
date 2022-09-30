class ForwardsMailbox < ApplicationMailbox
  # Callbacks specify prerequisites to processing
  before_processing :check_if_client, :check_if_valid_block

  def process
    # Record the forward on the one project, or…
    target_email = email_address_to_block

    service = forwarder.google_service

    mail_to = mail.to.first
    if mail_to.match?(/block/) && mail_to.match?(/domain/)
      service.create_domain_filters_for_everyone(target_email.split("@").last.to_s)
    elsif mail_to.match?(/block/)
      service.create_filter_for(user_email: forwarder.email, email_pattern: target_email)
    end
    # TODO: add the block rule to our database so that filters can be recreated
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
