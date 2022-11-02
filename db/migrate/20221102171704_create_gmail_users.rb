class CreateGmailUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :gmail_users do |t|
      t.string :email
      t.references :organization, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.string :gid
      t.text :full_name
      t.boolean :archived, null: false, default: false
      t.timestamp :google_created_at

      t.timestamps
    end
  end
end
