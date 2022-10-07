class Organization < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :filter_rules

  encrypts :google_domain_wide_delegation_credentials

  def self.for_user_email(email_address)
    domain = email_address.split("@").last.downcase
    find_by(domain: domain)
  end

  def google_service
    Google::Service.new(
      credentials_json: google_domain_wide_delegation_credentials,
      org_admin_email: admin_email
    )
  end
end
