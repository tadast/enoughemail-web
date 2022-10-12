class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, :rememberable, omniauth_providers: [:google_oauth2]

  belongs_to :organization, optional: true
  has_many :filter_rules
  has_many :organization_filter_rules, through: :organization, source: :filter_rules

  def self.from_google(google_params)
    User.find_or_create_by!(provider: "google", uid: google_params.fetch(:uid), email: google_params.fetch(:email).downcase).tap do |user|
      unless user.organization
        user.update!(
          organization: Organization.for_user_email(user.email)
        )
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
