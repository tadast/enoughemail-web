class FilterRuleApplicationJob < ApplicationJob
  def perform(filter_rule:)
    filter_rule.apply_to_google!
  end
end
