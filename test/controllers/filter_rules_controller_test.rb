require "test_helper"

class FilterRulesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @filter_rule = filter_rules(:domain)
  end

  test "should get index" do
    sign_in users(:one)
    get filter_rules_url
    assert_response :success
  end

  test "should destroy filter_rule" do
    sign_in users(:one)

    assert_no_enqueued_jobs

    delete filter_rule_url(@filter_rule)

    assert_enqueued_jobs 1, only: FilterRuleRemovalJob

    assert_redirected_to filter_rules_url(except: @filter_rule.id)
  end
end
