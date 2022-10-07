class Users::SessionsController < ApplicationController
  before_action :redirect_authenticated_to_root, only: [:new]
  def new
  end

  def destroy
    # TODO
  end

  private

  def redirect_authenticated_to_root
    return unless user_signed_in?
    redirect_to new_organization_path unless current_user.organization
    redirect_to current_user.organization
  end
end
