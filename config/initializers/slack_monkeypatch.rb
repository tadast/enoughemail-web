require "omniauth/strategies/slack"

# https://github.com/kmrshntr/omniauth-slack/pull/68#issuecomment-1328071627
OmniAuth::Strategies::Slack.option(:client_options, {
  site: "https://slack.com",
  token_url: "/api/oauth.v2.access"
})
