class CreateFilterRules < ActiveRecord::Migration[7.0]
  def change
    create_table :filter_rules do |t|
      t.string :email_pattern, null: false
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.string :source
      t.string :scope
      t.boolean :applied, default: false, null: false

      t.timestamps
    end
  end
end
