require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "redirects common email provider user to a special page" do
    sign_in users(:common_email_provider)

    get new_users_session_url
    assert_redirected_to common_domain_organization_path
  end

  test "redirects existing user to their organisation" do
    sign_in users(:one)

    get new_users_session_url
    assert_redirected_to organization_path(organizations(:one))
  end

  test "redirects the user to set up an organization" do
    sign_in users(:organizationless)

    get new_users_session_url
    assert_redirected_to onboarding_organizations_path
  end
end
