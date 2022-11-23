class ChangeFilterRuleEmailPatternToText < ActiveRecord::Migration[7.0]
  def up
    change_column :filter_rules, :email_pattern, :text
  end

  def down
    change_column :filter_rules, :email_pattern, :string
  end
end
