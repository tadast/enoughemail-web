class GmailUser < ApplicationRecord
  belongs_to :organization
  belongs_to :user, optional: true

  encrypts :email, deterministic: true, downcase: true
  encrypts :full_name

  def self.from_google(g_user)
    gmail_user = find_or_initialize_by(
      email: g_user.primary_email,
      gid: g_user.id
    )

    gmail_user.attributes = {
      full_name: g_user.name&.full_name,
      archived: g_user.archived,
      google_created_at: g_user.creation_time
    }

    gmail_user
  end
end
