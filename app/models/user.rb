class User < ApplicationRecord
  ROLES = %w[imported signed_up regular admin deactivated].freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, :rememberable, omniauth_providers: [:google_oauth2]

  belongs_to :organization, optional: true
  has_many :filter_rules
  has_many :organization_filter_rules, through: :organization, source: :filter_rules

  enum role: ROLES.zip(ROLES).to_h

  def self.from_google(google_params)
    user = User.find_or_initialize_by(
      provider: "google",
      uid: google_params.fetch(:uid),
      email: google_params.fetch(:email).downcase
    )

    existing_org = Organization.for_user_email(user.email)

    if user.new_record?
      if existing_org
        user.organization = existing_org
        user.role = "signed_up"
      else
        user.role = "admin" # First user becomes an admin
      end

      user.save!
    elsif user.organization.nil? && existing_org # Existing user
      user.update!(
        organization: Organization.for_user_email(user.email)
      )
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
