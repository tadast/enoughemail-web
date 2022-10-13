class OrganizationCredentialsTestsController < AuthenticatedController
  def show
  end

  def create
    service = current_user.google_service
    error_messages = []
    begin
      users = service.users
      filters = service.list_filters(user_email: users.last.emails.first["address"])
    rescue OpenSSL::PKey::RSAError => e
      error_messages << "The 'private_key' part of Google Credentials is invalid. Ensure newline characters are preserved as encoded '\\n'"
      Rails.logger.warn "Org #{current_user.organization_id} has invalid Google creds: #{e.class} #{e.message}"
    rescue MultiJson::ParseError => e
      error_messages << "Google credentials has to be a valid JSON object"
      Rails.logger.warn "Org #{current_user.organization_id} has invalid Google creds: #{e.class} #{e.message}"
    rescue Signet::AuthorizationError => e
      error_messages << "Google credentials unauthorized. Have they expired or were removed?"
      Rails.logger.warn "Org #{current_user.organization_id} has invalid Google creds: #{e.class} #{e.message}"
    end

    if error_messages.empty? && filters.is_a?(Google::Apis::GmailV1::ListFiltersResponse) && users.is_a?(Array)
      render partial: "success", status: :ok
    else
      render partial: "failure", locals: {error_messages: error_messages}, status: :unprocessable_entity
    end
  end
end
