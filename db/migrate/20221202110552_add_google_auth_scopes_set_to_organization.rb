class AddGoogleAuthScopesSetToOrganization < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :google_auth_scope_set, :text, default: "with_labels"

    Organization.update_all(google_auth_scope_set: "minimal")
  end
end
