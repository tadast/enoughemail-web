class Organization < ApplicationRecord
  has_many :users
  has_many :filter_rules

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
