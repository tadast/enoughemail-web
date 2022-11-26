class FilterList < ApplicationRecord
  has_many :filter_rules

  validates :name, presence: true
  validates :email_pattern, presence: true

  def sample_rule_for(organization)
    organization.filter_rules.where(filter_list: self).first
  end

  def applied?(organization)
    organization.applied_filter_lists.include?(self)
  end

  def apply!(by:, organization:)
    filter_rules = nil
    self.class.transaction do
      filter_rules = email_pattern_as_array_for_gmail.map do |pattern|
        by.filter_rules.create!(
          organization: organization,
          email_pattern: pattern,
          filter_list: self,
          scope: :for_everyone,
          source: :filter_list
        )
      end
    end
    filter_rules.map { |fr| FilterRuleApplicationJob.perform_later(filter_rule: fr) }

    if organization.slack_webhook_url.present?
      payload = {
        message: ":goal_net: #{by.email} has applied '#{name}' Filter List for everyone.",
        attachments: [
          {
            color: "#36a64f",
            title: name,
            text: description,
            title_link: Rails.application.routes.url_helpers.filter_list_url(id)
          }
        ]
      }
      SlackNotificationJob.perform_later(webhook_url: organization.slack_webhook_url, payload: payload)
    end
  end

  def unapply!(by:, organization:)
    filter_rules = organization.filter_rules.where(filter_list: self)
    filter_rules.map do |filter_rule|
      FilterRuleRemovalJob.perform_later(filter_rule: filter_rule, user: by)
    end

    if organization.slack_webhook_url.present?
      payload = {
        message: ":broom: #{by.email} has removed '#{name}' Filter List for everyone.",
        attachments: [
          {
            color: "#36a64f",
            title: name,
            text: description,
            title_link: Rails.application.routes.url_helpers.filter_list_url(id)
          }
        ]
      }
      SlackNotificationJob.perform_later(webhook_url: organization.slack_webhook_url, payload: payload)
    end
  end

  def patterns_count
    email_pattern.to_s.split("OR").size
  end

  # Default Gmail filter criteria string has a max length of 1500, chop
  # the email pattern into syntactically valid chunks within length limits
  def email_pattern_as_array_for_gmail(string_to_split: email_pattern, max_length: 1500, separator: " OR ")
    return @email_pattern_as_array_for_gmail if @email_pattern_as_array_for_gmail
    return [string_to_split] if string_to_split.size <= max_length

    head = string_to_split[0..(max_length - 1)]

    # Partition bang on just before last separator within the limit
    reversed_index_of_last_separator = head.reverse.index(separator.reverse)
    index_of_last_full_email_pattern = max_length - reversed_index_of_last_separator - separator.length
    _, clean_head, tail = string_to_split.partition(/.{#{index_of_last_full_email_pattern}}/)

    # Tail will start with a separator, chop it off
    clean_tail = tail.sub(separator, "")

    @email_pattern_as_array_for_gmail = if tail.size <= max_length
      [clean_head, clean_tail]
    else
      chunked_tail = email_pattern_as_array_for_gmail(string_to_split: clean_tail, max_length: max_length, separator: separator)
      [clean_head].concat(chunked_tail)
    end.compact
  end
end
