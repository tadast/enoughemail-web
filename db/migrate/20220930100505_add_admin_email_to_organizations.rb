class AddAdminEmailToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :admin_email, :string
  end
end
