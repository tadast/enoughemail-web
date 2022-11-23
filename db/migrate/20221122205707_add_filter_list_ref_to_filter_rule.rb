class AddFilterListRefToFilterRule < ActiveRecord::Migration[7.0]
  def change
    add_reference :filter_rules, :filter_list, foreign_key: true
  end
end
