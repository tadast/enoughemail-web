require "test_helper"

class ForwardsMailboxTest < ActionMailbox::TestCase
  setup do
    @user_alias = email_addresses(:one_alias)
    @user = @user_alias.user
  end

  test "accepts an email via user primary emails" do
    receive_inbound_email_from_mail \
      to: "i@had.enoughemail.com",
      from: @user.email,
      subject: "Hello world!",
      body: "Hello? From: <sender-to-block@blockable.enoughemail.com>"

    assert_equal "sender-to-block@blockable.enoughemail.com", @user_alias.user.filter_rules.last.email_pattern
  end

  test "accepts an email via user alias" do
    receive_inbound_email_from_mail \
      to: "i@had.enoughemail.com",
      from: @user_alias.email,
      subject: "Hello world!",
      body: "Hello? From: <sender-to-block@blockable.enoughemail.com>"

    assert_equal "sender-to-block@blockable.enoughemail.com", @user_alias.user.filter_rules.last.email_pattern
  end

  test "does not create rules if sender is unknown" do
    assert_no_changes -> { FilterRule.count } do
      receive_inbound_email_from_mail \
        to: "i@had.enoughemail.com",
        from: "randomsender@nope.enoughemail.com",
        subject: "Hello world!",
        body: "Hello? From: <sender-to-block@blockable.enoughemail.com>"
    end
  end
end
