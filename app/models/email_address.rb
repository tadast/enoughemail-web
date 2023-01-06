class EmailAddress < ApplicationRecord
  belongs_to :gmail_user
  has_one :user, through: :gmail_user

  validates :email, presence: true
  encrypts :email, deterministic: true, downcase: true
end
