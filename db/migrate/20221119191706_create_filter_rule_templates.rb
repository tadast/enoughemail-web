class CreateFilterRuleTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :filter_rule_templates do |t|
      t.text :name
      t.text :description
      t.text :email_pattern

      t.timestamps
    end
  end
end
