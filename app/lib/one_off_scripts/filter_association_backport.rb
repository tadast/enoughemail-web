class OneOffScripts::FilterAssociationBackport
  def run
    Organization.all.includes(filter_rules: {gmail_user_filter_rules: :gmail_user}).each do |org|
      puts "============"
      puts org.domain
      service = org.google_service

      org.filter_rules.each do |filter_rule|
        puts "\t #{filter_rule.email_pattern} #{filter_rule.scope}"

        users = if filter_rule.scope == :for_everyone
          service.users
        else
          [service.get_user(user_email: filter_rule.user.email)]
        end

        users.each do |g_user|
          puts "\t\t #{g_user.primary_email}"

          already_persisted = filter_rule.gmail_user_filter_rules.joins(:gmail_user).where(gmail_user: {email: g_user.primary_email}).exists?

          puts "\t\t\t Already persisted" if already_persisted
          next if already_persisted

          gmail_user = GmailUser.from_google(g_user).with_associations_for_new_record(org)

          filter = service.find_filter_for(user_email: g_user.primary_email, email_pattern: filter_rule.email_pattern)

          if filter
            id = GmailUserFilterRule.upsert(
              {
                gmail_user_id: gmail_user.id,
                filter_rule_id: filter_rule.id,
                google_filter_id: filter.id
              },
              unique_by: [:gmail_user_id, :filter_rule_id, :google_filter_id]
            )
            puts "\t\t\t Persisted as #{id}"
          else
            puts "\t\t\t Filter not found on Gmail" # TODO: create one?
          end
        end
      end
    end
  end
end

# FilterAssociationBackport.new.run
