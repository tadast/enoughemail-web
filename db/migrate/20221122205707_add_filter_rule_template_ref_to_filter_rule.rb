class AddFilterRuleTemplateRefToFilterRule < ActiveRecord::Migration[7.0]
  def change
    add_reference :filter_rules, :filter_rule_template, foreign_key: true
  end
end
