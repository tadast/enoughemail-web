class OrganizationCredentialsTestsController < AuthenticatedController
  def show
  end

  def create
    service = current_user.google_service
    error_messages = {}
    users = nil
    error_messages[:user_access] = check_for_errors do
      users = service.users
    end

    if users
      error_messages[:gmail_basic_settings_access] = check_for_errors do
        service.list_filters(user_email: users.last.emails.first["address"])
      end
    end

    if error_messages.values.flatten.empty?
      render partial: "success", status: :ok
    else
      render partial: "failure", locals: {error_messages: error_messages}, status: :unprocessable_entity
    end
  end

  private

  def check_for_errors(&block)
    error_messages = []
    begin
      yield
    rescue OpenSSL::PKey::RSAError => e
      error_messages << "The 'private_key' part of Google Credentials is invalid. Ensure newline characters are preserved as encoded '\\n'"
      Rails.logger.warn "Org #{current_user.organization_id} has invalid Google creds: #{e.class} #{e.message}"
    rescue MultiJson::ParseError => e
      error_messages << "Google credentials has to be a valid JSON object"
      Rails.logger.warn "Org #{current_user.organization_id} has invalid Google creds: #{e.class} #{e.message}"
    rescue Signet::AuthorizationError => e
      error_messages << "Google credentials unauthorized. Have they expired or were removed? Are all access scopes configured correctly?"
      Rails.logger.warn "Org #{current_user.organization_id} has invalid Google creds: #{e.class} #{e.message}"
    end

    error_messages
  end
end
