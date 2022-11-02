class Google::Service
  SCOPES = [Google::Apis::AdminDirectoryV1::AUTH_ADMIN_DIRECTORY_USER_READONLY, Google::Apis::GmailV1::AUTH_GMAIL_SETTINGS_BASIC]
  FILTER_LABELS_TO_REMOVE = ["UNREAD", "IMPORTANT", "INBOX"].sort.freeze

  def initialize(credentials_json:, org_admin_email:)
    @credentials_json = credentials_json
    @org_admin_email = org_admin_email
  end

  def service_authorization(as: @org_admin_email)
    auth = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(@credentials_json),
      scope: SCOPES
    ).dup
    auth.sub = as
    auth
  end

  def users(as_seen_by: @org_admin_email, service: nil, page_token: nil)
    if service.nil?
      service = Google::Apis::AdminDirectoryV1::DirectoryService.new
      # service.client_options.application_name = APPLICATION_NAME
      service.authorization = service_authorization(as: as_seen_by)
      # List the first 10 users in the domain
    end

    # return super administrators: query: "isAdmin=true" / delegated admins query: "isDelegatedAdmin=true"
    response = service.list_users(customer: "my_customer",
      max_results: 100,
      order_by: "email",
      page_token: page_token)

    raw_users = response.users.filter { |user| !user.suspended? && user.is_mailbox_setup? }

    if response.next_page_token
      raw_users + users(as_seen_by: as_seen_by, service: service, page_token: response.next_page_token)
    else
      raw_users
    end
  end

  def list_filters(user_email:)
    gmail = Google::Apis::GmailV1::GmailService.new
    gmail.authorization = service_authorization(as: user_email)
    # TODO: is there any pagination?
    gmail.list_user_setting_filters("me").filter
  end

  def delete_filter_for_everyone(email_pattern:)
    users.each do |user|
      email = user.primary_email

      delete_filter_for(user_email: email, email_pattern: email_pattern)
    end
  end

  def delete_filter_for(user_email:, email_pattern:)
    filters = list_filters(user_email: user_email)

    relevant_filters = filters.select do |filter|
      filter.criteria.from.to_s.downcase == email_pattern &&
        filter.action.remove_label_ids.sort == FILTER_LABELS_TO_REMOVE
    end

    gmail = gmail_service(as: user_email)

    relevant_filters.each do |filter|
      gmail.delete_user_setting_filter("me", filter.id)
    end
  end

  def everyones_filters
    users.map do |user|
      email = user.primary_email

      filters = list_filters(user_email: email)
      Rails.logger.info "#{email}: #{filters}"

      [email, filters]
    end
  end

  def create_filters_for_everyone(email_pattern:)
    users.map do |user|
      email = user.primary_email

      create_filter_for(user_email: email, email_pattern: email_pattern)
    end
  end

  def create_filter_for(user_email:, email_pattern:)
    gmail = gmail_service(as: user_email)

    gmail.create_user_setting_filter(
      "me",
      Google::Apis::GmailV1::Filter.new(
        action: Google::Apis::GmailV1::FilterAction.new(remove_label_ids: ["UNREAD", "IMPORTANT", "INBOX"]),
        criteria: Google::Apis::GmailV1::FilterCriteria.new(from: email_pattern)
      ),
      fields: nil,
      quota_user: nil,
      options: nil
    )
  end

  private

  def gmail_service(as: user_email)
    gmail = Google::Apis::GmailV1::GmailService.new
    gmail.authorization = service_authorization(as: as)

    gmail
  end
end
