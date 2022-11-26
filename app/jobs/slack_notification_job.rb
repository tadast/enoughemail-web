require "open-uri"
require "net/http"

class SlackNotificationJob < ApplicationJob
  def perform(webhook_url:, payload:)
    slack = Slack::Incoming::Webhooks.new(webhook_url)
    slack.post(payload.delete(:message), payload)
  end
end
