class ReportUsersWithoutFilters
  def run
    GmailUser.includes(organization: :filter_rules).all.map do |gmail_user|
      missing_rules = gmail_user.organization.filter_rules.for_everyone.where.not(id: gmail_user.filter_rules.pluck(:id))
      [gmail_user.email, missing_rules.map(&:email_pattern)]
    end.to_h
  end
end
