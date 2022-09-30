class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, :rememberable, omniauth_providers: [:google_oauth2]

  belongs_to :organization

  def self.from_google(google_params)
    User.find_or_create_by!(provider: "google", uid: google_params.fetch(:uid), email: google_params.fetch(:email).downcase)
  end

  def google_service
    # TODO: return if not a moderator?
    organization.google_service
  end
end
