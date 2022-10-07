require "test_helper"

class FilterRulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @filter_rule = filter_rules(:one)
  end

  test "should get index" do
    get filter_rules_url
    assert_response :success
  end

  test "should get new" do
    get new_filter_rule_url
    assert_response :success
  end

  test "should create filter_rule" do
    assert_difference("FilterRule.count") do
      post filter_rules_url, params: {filter_rule: {email_pattern: @filter_rule.email_pattern}}
    end

    assert_redirected_to filter_rule_url(FilterRule.last)
  end

  test "should show filter_rule" do
    get filter_rule_url(@filter_rule)
    assert_response :success
  end

  test "should get edit" do
    get edit_filter_rule_url(@filter_rule)
    assert_response :success
  end

  test "should update filter_rule" do
    patch filter_rule_url(@filter_rule), params: {filter_rule: {email_pattern: @filter_rule.email_pattern}}
    assert_redirected_to filter_rule_url(@filter_rule)
  end

  test "should destroy filter_rule" do
    assert_difference("FilterRule.count", -1) do
      delete filter_rule_url(@filter_rule)
    end

    assert_redirected_to filter_rules_url
  end
end
