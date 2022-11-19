require "test_helper"

class FilterRuleTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @filter_rule_template = filter_rule_templates(:one)
  end

  test "should get index" do
    get filter_rule_templates_url
    assert_response :success
  end

  test "should get new" do
    get new_filter_rule_template_url
    assert_response :success
  end

  test "should create filter_rule_template" do
    assert_difference("FilterRuleTemplate.count") do
      post filter_rule_templates_url, params: {filter_rule_template: {description: @filter_rule_template.description, email_pattern: @filter_rule_template.email_pattern, name: @filter_rule_template.name}}
    end

    assert_redirected_to filter_rule_template_url(FilterRuleTemplate.last)
  end

  test "should show filter_rule_template" do
    get filter_rule_template_url(@filter_rule_template)
    assert_response :success
  end

  test "should get edit" do
    get edit_filter_rule_template_url(@filter_rule_template)
    assert_response :success
  end

  test "should update filter_rule_template" do
    patch filter_rule_template_url(@filter_rule_template), params: {filter_rule_template: {description: @filter_rule_template.description, email_pattern: @filter_rule_template.email_pattern, name: @filter_rule_template.name}}
    assert_redirected_to filter_rule_template_url(@filter_rule_template)
  end

  test "should destroy filter_rule_template" do
    assert_difference("FilterRuleTemplate.count", -1) do
      delete filter_rule_template_url(@filter_rule_template)
    end

    assert_redirected_to filter_rule_templates_url
  end
end
