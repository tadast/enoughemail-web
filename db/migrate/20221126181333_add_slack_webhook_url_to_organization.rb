class AddSlackWebhookUrlToOrganization < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :slack_webhook_url, :text
  end
end
