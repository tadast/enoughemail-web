class OneOffScripts::ImportUserAliases
  def run
    Organization.find_each do |organization|
      service = organization.google_service

      organization.users.each do |user|
        g_user = service.get_user(user_email: user.email)

        unless g_user
          Rails.logger.info "Skipping aliases for #{user.email}: no google user found" and next
        end

        unless user.gmail_user
          Rails.logger.info "Skipping aliases for #{user.email}: no GmailUser found" and next
        end

        user.gmail_user.persist_aliases(g_user)
      rescue Google::Apis::ClientError => e
        Rails.logger.warn "Could not assign aliases for #{user.email}: #{e.message}"
      end
    end
  end
end
