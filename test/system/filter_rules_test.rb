require "application_system_test_case"

class FilterRulesTest < ApplicationSystemTestCase
  setup do
    @filter_rule = filter_rules(:one)
  end

  test "visiting the index" do
    visit filter_rules_url
    assert_selector "h1", text: "Filter rules"
  end

  test "should create filter rule" do
    visit filter_rules_url
    click_on "New filter rule"

    fill_in "Email pattern", with: @filter_rule.email_pattern
    click_on "Create Filter rule"

    assert_text "Filter rule was successfully created"
    click_on "Back"
  end

  test "should update Filter rule" do
    visit filter_rule_url(@filter_rule)
    click_on "Edit this filter rule", match: :first

    fill_in "Email pattern", with: @filter_rule.email_pattern
    click_on "Update Filter rule"

    assert_text "Filter rule was successfully updated"
    click_on "Back"
  end

  test "should destroy Filter rule" do
    visit filter_rule_url(@filter_rule)
    click_on "Destroy this filter rule", match: :first

    assert_text "Filter rule was successfully destroyed"
  end
end
