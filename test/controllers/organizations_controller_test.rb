require "test_helper"

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should allow GETing new for a user with no organization" do
    sign_in users(:organizationless)

    get new_organization_url
    assert_response :success
  end

  test "should redirect to an existing organization, if present" do
    sign_in users(:one)

    get new_organization_url
    assert_response :redirect
  end

  test "should create organization" do
    sign_in users(:organizationless)

    assert_difference("Organization.count") do
      post organizations_url, params: {
        organization: {
          billing_email: "bills@testX.enoughemail.com",
          domain: "testX.enoughemail.com",
          admin_email: "admin@testX.enoughemail.com",
          google_domain_wide_delegation_credentials: {}.to_json
        }
      }
    end

    assert_redirected_to organization_url(Organization.last)
  end

  test "should show organization" do
    user = users(:one)
    sign_in user
    get organization_url(user.organization)
    assert_response :success
  end

  test "should get edit" do
    user = users(:one)
    sign_in user
    get edit_organization_url(user.organization)
    assert_response :success
  end

  test "should update organization" do
    user = users(:one)
    sign_in user
    patch organization_url(user.organization), params: {
      organization: {
        billing_email: "new-billing@test.enoughemail.com",
        domain: user.organization.domain,
        google_domain_wide_delegation_credentials: {a: 1}.to_json
      }
    }

    assert_redirected_to organization_url(user.organization)
    assert_equal "new-billing@test.enoughemail.com", user.organization.billing_email
  end
end
