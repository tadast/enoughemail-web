class FilterRuleRemovalJob < ApplicationJob
  def perform(filter_rule:, user:)
    raise "Rule not owned" unless user.organization_id == filter_rule.organization_id

    service = user.google_service
    if filter_rule.for_everyone?
      service.delete_filter_for_everyone(email_pattern: filter_rule.email_pattern)
    else
      service.delete_filter_for(user_email: filter_rule.user.email, email_pattern: filter_rule.email_pattern)
    end

    filter_rule.destroy
  end
end
