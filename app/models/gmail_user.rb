class GmailUser < ApplicationRecord
  belongs_to :organization
  belongs_to :user, optional: true
  has_many :gmail_user_filter_rules, dependent: :destroy
  has_many :filter_rules, through: :gmail_user_filter_rules
  has_many :email_addresses, dependent: :destroy

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

    gmail_user.persist_aliases(g_user)

    gmail_user
  end

  def persist_aliases(g_user)
    raise "primary email does not match for #{id}!" unless email == g_user.primary_email

    aliases = [g_user.primary_email] + g_user.aliases.to_a + g_user.non_editable_aliases.to_a
    suitable_aliases = aliases.reject { |email_address| email_address.end_with?(".test-google-a.com") }

    email_addresses.replace(
      suitable_aliases.map do |email|
        EmailAddress.new(email: email)
      end
    )
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
