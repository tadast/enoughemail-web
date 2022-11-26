class FilterRule < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  belongs_to :filter_list, optional: true
  has_many :gmail_user_filter_rules, dependent: :destroy
  has_many :gmail_users, through: :gmail_user_filter_rules

  validates :scope, presence: true, inclusion: %w[for_everyone for_individual]
  validates :source, presence: true, inclusion: %w[email ui filter_list]
  validates :email_pattern, presence: true

  scope :without_filter_list, -> { where(filter_list_id: nil) }

  enum scope: {
    for_everyone: "for_everyone",
    for_individual: "for_individual"
  }

  enum source: {
    email: "email",
    ui: "ui",
    filter_list: "filter_list"
  }

  def apply_to_google!
    if for_everyone?
      apply_to_everyone_on_gmail
    else
      service = user.service
      g_user = service.get_user(user_email: user.email)
      apply_to_gmail_and_persist(service: service, g_user: g_user)
    end
    update!(applied: true)

    if organization.slack_webhook_url.present? && for_everyone? && filter_list_id.nil?
      SlackNotificationJob.perform_later(webhook_url: organization.slack_webhook_url, payload: creation_event_slack_payload)
    end
  end

  private

  def creation_event_slack_payload
    target_audience = for_individual? ? "for themselves" : scope.humanize.downcase
    message = ":hand: #{user&.email || "Deleted user"} has created a filter to block `#{email_pattern}` #{target_audience}."
    {
      message: message,
      attachments: [
        {
          color: "#36a64f",
          title: "Review all filters",
          title_link: Rails.application.routes.url_helpers.filter_rules_url
        }
      ]
    }
  end

  def apply_to_gmail_and_persist(service:, g_user:)
    gmail_user = GmailUser.from_google(g_user).with_associations_for_new_record(organization)

    g_filter = service.create_filter_for(
      user_email: g_user.primary_email,
      email_pattern: email_pattern
    )

    GmailUserFilterRule.upsert(
      {
        gmail_user_id: gmail_user.id,
        filter_rule_id: id,
        google_filter_id: g_filter.id
      },
      unique_by: [:gmail_user_id, :filter_rule_id, :google_filter_id]
    )
  end

  def apply_to_everyone_on_gmail
    service = user.google_service
    g_users = service.users

    g_users.each do |g_user|
      apply_to_gmail_and_persist(service: service, g_user: g_user)
    end
  end
end
