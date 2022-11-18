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
    service ||= directory_service(as: as_seen_by)

    # to return super administrators: query: "isAdmin=true" / delegated admins query: "isDelegatedAdmin=true"
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

  def get_user(user_email:, as_seen_by: @org_admin_email)
    directory_service(as: as_seen_by).get_user(user_email)
  end

  def list_filters(user_email:)
    gmail = Google::Apis::GmailV1::GmailService.new
    gmail.authorization = service_authorization(as: user_email)
    # TODO: is there any pagination?
    gmail.list_user_setting_filters("me").filter
  end

  def everyones_filters
    users.map do |user|
      email = user.primary_email

      filters = list_filters(user_email: email)
      Rails.logger.info "#{email}: #{filters}"

      [email, filters]
    end
  end

  # def delete_filter_for_everyone(email_pattern:)
  #   users.each do |user|
  #     email = user.primary_email

  #     delete_filter_for(user_email: email, email_pattern: email_pattern)
  #   end
  # end

  def delete_filter_for(user_email:, email_pattern:)
    relevant_filter = find_filter_for(user_email: user_email, email_pattern: email_pattern)

    delete_filter(relevant_filter.id, as: user_email)
  end

  def delete_filter(filter_id, as:)
    gmail = gmail_service(as: as)

    begin
      gmail.delete_user_setting_filter("me", filter_id)
    rescue Google::Apis::ClientError => e
      if e.status_code == 404
        Rails.logger.warn("Gmail filter '#{filter_id}' not found for #{as}, skipping")

        return
      end
      raise
    end
  end

  def find_filter_for(user_email:, email_pattern:)
    filters = list_filters(user_email: user_email)

    filters.find do |filter|
      filter.criteria.from.to_s.downcase == email_pattern &&
        filter.action.remove_label_ids.sort == FILTER_LABELS_TO_REMOVE
    end
  end

  def create_filter_for(user_email:, email_pattern:)
    gmail = gmail_service(as: user_email)

    begin
      gmail.create_user_setting_filter(
        "me",
        Google::Apis::GmailV1::Filter.new(
          action: Google::Apis::GmailV1::FilterAction.new(remove_label_ids: FILTER_LABELS_TO_REMOVE),
          criteria: Google::Apis::GmailV1::FilterCriteria.new(from: email_pattern)
        ),
        fields: nil,
        quota_user: nil,
        options: nil
      )
    rescue Google::Apis::ClientError => e
      raise unless e.message == "failedPrecondition: Filter already exists"

      Honeybadger.notify(e.message)

      find_filter_for(user_email: user_email, email_pattern: email_pattern)
    end
  end

  private

  def gmail_service(as:)
    @gmail_service ||= {}
    @gmail_service[as] = begin
      gmail = Google::Apis::GmailV1::GmailService.new
      gmail.authorization = service_authorization(as: as)

      gmail
    end
  end

  def directory_service(as:)
    admin_directory_service = Google::Apis::AdminDirectoryV1::DirectoryService.new
    admin_directory_service.authorization = service_authorization(as: as)

    admin_directory_service
  end
end
