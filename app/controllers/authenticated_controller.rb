class AuthenticatedController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_organisation_set_up

  private

  def ensure_organisation_set_up
    if current_user.organization.nil?
      if EmailDomain.from_address(current_user.email).common?
        redirect_to common_domain_organization_path and return
      else
        redirect_to onboarding_organizations_path and return
      end
    end
  end
end
