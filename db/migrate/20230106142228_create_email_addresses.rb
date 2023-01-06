class CreateEmailAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :email_addresses do |t|
      t.references :gmail_user, null: false, foreign_key: true
      t.text :email

      t.timestamps
    end
  end
end
