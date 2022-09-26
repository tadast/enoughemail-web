class ForwardsMailbox < ApplicationMailbox
  # Callbacks specify prerequisites to processing
  before_processing :check_if_client

  def process
    # Record the forward on the one project, or…
    # binding.pry
  end

  private

  def check_if_client
    if forwarder.nil?
      # Use Action Mailers to bounce incoming emails back to sender – this halts processing
      # bounce_with Forwards::BounceMailer.no_projects(inbound_email, forwarder: forwarder)
    end
  end

  def forwarder
    # TODO: check for spoofing
    # @forwarder ||= User.find_by(email_address: mail.from)
  end
end
