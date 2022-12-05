class OneOffScripts::RecreateFilters
  attr_reader :organization

  def initialize(organization)
    @organization = organization
  end

  def run
    organization.filter_rules.includes(gmail_user_filter_rules: :gmail_user).flat_map do |fr|
      fr.gmail_user_filter_rules.map do |x|
        Rails.logger.info "Recreating #{fr.email_pattern} rule for #{x.gmail_user.email} in #{organization.domain}"

        x.recreate_on_gmail
      end
    end
  end
end
