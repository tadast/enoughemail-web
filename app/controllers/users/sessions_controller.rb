class Users::SessionsController < ApplicationController
  before_action :redirect_authenticated_to_root, only: [:new]
  def new
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def redirect_authenticated_to_root
    return unless user_signed_in?
    if current_user.organization.nil?
      if EmailDomain.from_address(current_user.email).common?
        redirect_to common_domain_organization_path and return
      else
        redirect_to new_organization_path and return
      end
    end
    redirect_to current_user.organization
  end
end
