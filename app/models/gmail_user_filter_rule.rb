class GmailUserFilterRule < ApplicationRecord
  belongs_to :gmail_user
  belongs_to :filter_rule
  has_one :organization, through: :gmail_user

  validates :google_filter_id, presence: true

  def recreate_on_gmail
    remove_on_gmail
    apply_on_gmail
  end

  def remove_on_gmail
    google_service.delete_filter(google_filter_id, as: gmail_user.email)
  end

  def apply_on_gmail
    filter = google_service.create_filter_for(user_email: gmail_user.email, email_pattern: filter_rule.email_pattern)
    update!(google_filter_id: filter.id)
  end

  private

  def google_service
    @google_service ||= organization.google_service
  end
end
