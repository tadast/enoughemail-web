class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.text :domain
      t.string :billing_email
      t.text :google_domain_wide_delegation_credentials

      t.timestamps
    end
  end
end
