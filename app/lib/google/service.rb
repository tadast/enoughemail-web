class Google::Service
  SCOPES = [Google::Apis::AdminDirectoryV1::AUTH_ADMIN_DIRECTORY_USER_READONLY, Google::Apis::GmailV1::AUTH_GMAIL_SETTINGS_BASIC]

  def initialize(credentials_json:)
    @credentials_json = credentials_json
  end

  def service_authorization(as:)
    auth = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(@credentials_json),
      scope: SCOPES
    ).dup
    auth.sub = as
    auth
  end

  def users(as_seen_by:)
    service = Google::Apis::AdminDirectoryV1::DirectoryService.new
    # service.client_options.application_name = APPLICATION_NAME
    service.authorization = service_authorization(as: as_seen_by)
    # List the first 10 users in the domain

    # return super administrators: query: "isAdmin=true" / delegated admins query: "isDelegatedAdmin=true"
    response = service.list_users(customer: "my_customer",
                                  max_results: 10,
                                  order_by:    "email")
    # puts "Users:"
    # puts "No users found" if response.users.empty?
    # response.users.each { |user| puts "- #{user.primary_email} (#{user.name.full_name})" }

    response.users.filter { |user| !user.suspended? && user.is_mailbox_setup? }
  end

  def list_filters(user_email:)
    gmail = Google::Apis::GmailV1::GmailService.new
    gmail.authorization = service_authorization(as: user_email)
    gmail.list_user_setting_filters('me')
  end

  def everyones_filters
    users.each do |user|
      email = user.emails.first { |h| h["primary"] }["address"]
      filters = list_filters(user_email: email)
      puts "#{email}: #{filters}"
    end
  end

  def filter_domain_for_everyone(domain: )

  end

  def create_domain_filter_for(user_email: , domain: )
    gmail = Google::Apis::GmailV1::GmailService.new
    gmail.authorization = service_authorization(as: user_email)

    safe_domain = domain.split('@').last.to_s

    raise "invalid domain: #{domain}" unless safe_domain.to_s.size > 4 && safe_domain.include?('.')
    # create_user_setting_filter(user_id, filter_object = nil, fields: nil, quota_user: nil, options: nil) {|result, err| ... } ⇒ Google::Apis::GmailV1::Filter
    gmail.create_user_setting_filter(
      "me",
      Google::Apis::GmailV1::Filter.new(
        action: Google::Apis::GmailV1::FilterAction.new(remove_label_ids: ["UNREAD", "IMPORTANT", "INBOX"]),
        criteria: Google::Apis::GmailV1::FilterCriteria.new(from: "*@#{safe_domain}")
      ),
      fields: nil,
      quota_user: nil,
      options: nil
    )
  end
end