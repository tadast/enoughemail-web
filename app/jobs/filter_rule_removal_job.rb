class FilterRuleRemovalJob < ApplicationJob
  def perform(filter_rule:, user:)
    raise "Rule not owned" unless user.organization_id == filter_rule.organization_id

    service = user.google_service

    filter_rule.gmail_user_filter_rules.each do |gufr|
      service.delete_filter(gufr.google_filter_id, as: gufr.gmail_user.email)
    end

    if filter_rule.for_everyone? && filter_rule.organization.slack_webhook_url.present?
      SlackNotificationJob.perform_later(
        webhook_url: filter_rule.organization.slack_webhook_url,
        payload: {
          message: ":broom: #{user.email} has removed `#{filter_rule.email_pattern}` filter for everyone."
        }
      )
    end

    filter_rule.destroy
  end
end
