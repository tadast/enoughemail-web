class CreateGmailUserFilterRules < ActiveRecord::Migration[7.0]
  def change
    create_table :gmail_user_filter_rules do |t|
      t.references :gmail_user, null: false, foreign_key: true
      t.references :filter_rule, null: false, foreign_key: true
      t.text :google_filter_id, null: false

      t.timestamps

      t.index [:gmail_user_id, :filter_rule_id, :google_filter_id], unique: true, name: "index_gmail_user_filer_rule_uniqueness"
    end
  end
end
