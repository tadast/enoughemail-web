class Organization < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :gmail_users
  has_many :filter_rules
  has_many :applied_filter_rule_templates, -> { distinct }, through: :filter_rules, source: :filter_rule_template

  encrypts :google_domain_wide_delegation_credentials

  validates :domain, uniqueness: true, presence: true
  validates :google_domain_wide_delegation_credentials, presence: true
  validate :non_common_domain

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

  private

  def non_common_domain
    errors.add(:domain, "is a common domain") if EmailDomain.new(domain).common?
  end
end
