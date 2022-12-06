class OneOffScripts::UsersWithoutFilters
  def apply
    GmailUser.includes(organization: :filter_rules).all.map do |gmail_user|
      missing_rules = gmail_user.organization.filter_rules.for_everyone.where.not(id: gmail_user.filter_rules.pluck(:id))
      next unless missing_rules.present?

      service = gmail_user.organization.google_service
      g_user = nil

      begin
        g_user = service.get_user(user_email: gmail_user.email)
      rescue Google::Apis::ClientError => e
        raise unless e.status_code == 404

        gmail_user.destroy
      end

      missing_rules.map do |filter_rule|
        filter_rule.apply_to_gmail_and_persist(service: service, g_user: g_user)
      end
    end
  end

  def report
    GmailUser.includes(organization: :filter_rules).all.map do |gmail_user|
      missing_rules = gmail_user.organization.filter_rules.for_everyone.where.not(id: gmail_user.filter_rules.pluck(:id))
      [gmail_user.email, missing_rules.map(&:email_pattern)]
    end.to_h
  end
end
