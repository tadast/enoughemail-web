class OneOffScripts::ReportOfFilteredEmails
  attr_reader :organization

  def initialize(organization)
    @organization = organization
  end

  def run
    service.users.map do |g_user|
      label = service.get_label_with_details_by_name(label_name: Google::Service::LABEL_ENOUGH_EMAIL, user_email: g_user.primary_email)
      [g_user.primary_email, label&.messages_total]
    end.to_h
  end

  private

  def service
    @service ||= organization.google_service
  end
end
