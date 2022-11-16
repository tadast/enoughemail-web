class GmailUser < ApplicationRecord
  belongs_to :organization
  belongs_to :user, optional: true
  has_many :gmail_user_filter_rules, dependent: :destroy
  has_many :filter_rules, through: :gmail_user_filter_rules

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

  def with_associations_for_new_record(organization)
    return self if persisted?

    update!(
      organization: organization,
      user: organization.users.find_by(email: email)
    )

    self
  end
end
