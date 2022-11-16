class GmailUserFilterRule < ApplicationRecord
  belongs_to :gmail_user
  belongs_to :filter_rule

  validates :google_filter_id, presence: true
end
