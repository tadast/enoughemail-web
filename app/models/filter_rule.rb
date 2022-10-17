class FilterRule < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :scope, presence: true, inclusion: %w[for_everyone for_individual]
  validates :source, presence: true, inclusion: %w[email ui]

  enum scope: {
    for_everyone: "for_everyone",
    for_individual: "for_individual"
  }

  enum source: {
    email: "email",
    ui: "ui"
  }

  def apply_to_google!
    service = user.google_service

    if scope.to_sym == :for_everyone
      service.create_filters_for_everyone(email_pattern: email_pattern) # FIXME: error handling, logging?
    else
      service.create_filter_for(user_email: user.email, email_pattern: email_pattern) # FIXME: error handling, logging?
    end
    update!(applied: true)
  end
end
