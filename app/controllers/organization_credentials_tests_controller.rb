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

    # This might not be required as 'service' will fail if authorized scopes do not match Google::Service::SCOPES
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
      response_body = JSON.parse(e.response.body)
      case response_body["error_description"].strip
      when "Invalid email or User ID"
        error_messages << "Google credentials unauthorized. Is 'Admin email' setting on the organization correct?"
      when "Requested client not authorized."
        error_messages << "Google credentials unauthorized. Are scopes in Google Workspace Admin panel for domain-wide delegation set up correctly?"
        error_messages << "Scopes required: '#{Google::Service::SCOPES.join(",")}'"
      else
        error_messages << "Google credentials unauthorized. Have they expired or were removed? Google error description: #{response_body["error_description"].strip}"
      end

      Rails.logger.warn "Org #{current_user.organization_id} has invalid Google creds: #{e.class} #{e.message}"
    end

    error_messages
  end
end
