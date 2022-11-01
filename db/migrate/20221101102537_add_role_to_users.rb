class AddRoleToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :role, :string, default: "imported"

    User.where.not(organization_id: nil).update_all(role: "admin")
  end

  def down
    remove_column :users, :role
  end
end
