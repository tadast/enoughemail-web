require "application_system_test_case"

class FilterRulesTest < ApplicationSystemTestCase
  setup do
    @filter_rule = filter_rules(:one)
  end

  test "visiting the index" do
    visit filter_rules_url
    assert_selector "h1", text: "Filters"
  end

  test "should create filter" do
    visit filter_rules_url
    click_on "New filter"

    fill_in "Email pattern", with: @filter_rule.email_pattern
    click_on "Create Filter"

    assert_text "Filter was successfully created"
    click_on "Back"
  end

  test "should update Filter" do
    visit filter_rule_url(@filter_rule)
    click_on "Edit this filter", match: :first

    fill_in "Email pattern", with: @filter_rule.email_pattern
    click_on "Update Filter"

    assert_text "Filter was successfully updated"
    click_on "Back"
  end

  test "should destroy Filter" do
    visit filter_rule_url(@filter_rule)
    click_on "Destroy this filter", match: :first

    assert_text "Filter was successfully destroyed"
  end
end
