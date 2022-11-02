class GmailUserImportJob < ApplicationJob
  def perform(organization:)
    service = organization.google_service

    g_users = service.users

    g_users.each do |g_user|
      gmail_user = GmailUser.from_google(g_user)
      gmail_user.organization = organization
      gmail_user.user = organization.users.find_by(email: gmail_user.email)

      gmail_user.save!
    end

    active_g_user_emails = g_users.reject { |gu| gu.archived }.map(&:primary_email)

    inactive_ids = organization.gmail_users.pluck(:id, :email).to_a.reject do |(id, email)|
      email.in?(active_g_user_emails)

      id
    end

    if inactive_ids.any?
      Honeybadger.notify("INACTIVE USERS DETECTED: #{inactive_ids}")
      Rails.logger.warn("INACTIVE USERS DETECTED: #{inactive_ids}")
    end
  end
end
