class FilterRule < ApplicationRecord
  belongs_to :user
  belongs_to :organization

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
    service.create_filters_for_everyone(email_pattern: email_pattern) # FIXME: error handling, logging?
    update!(applied: true)
  end
end
