class FilterRuleApplicationJob < ApplicationJob
  def perform(organization:)
    service = organization.google_service

    gmail_users = service.users

    gmail_users.each do |gmail_user|
      primary_email = gmail_user.emails.find { |h| h["primary"] }["address"]
      existing_user = User.find_by(email: primary_email)

      if existing_user
        # TODO: update status and aliases
      else
        User.create!(
          role: "imported",
          organization: organization,
          email: primary_email
        )
      end
    end
  end
end
