class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, :rememberable, omniauth_providers: [:google_oauth2, :slack]

  belongs_to :organization, optional: true
  has_one :gmail_user
  has_many :filter_rules
  has_many :organization_filter_rules, through: :organization, source: :filter_rules

  def self.from_google(google_params)
    User.find_or_create_by!(provider: "google", email: google_params.fetch(:email).downcase).tap do |user|
      if user.uid && user.uid != google_params.fetch(:uid)
        raise "Matching email but different uid for user #{user.id}"
      end

      if user.uid.nil?
        Rails.logger.info "Setting uid for a user who did not have it previously #{user.id}"
        user.update!(uid: google_params.fetch(:uid))
      end

      unless user.organization
        organization = Organization.for_user_email(user.email)
        user.update!(
          organization: organization
        )
        if organization&.slack_webhook_url.present?
          SlackNotificationJob.perform_later(
            webhook_url: organization.slack_webhook_url,
            payload: {
              message: ":wave: #{user.email} has joined the organization."
            }
          )
        end
      end
    end
  end

  def google_service
    # TODO: return nil if not a moderator?
    organization.google_service
  end

  def domain_from_email
    email.downcase.split("@").last
  end
end
