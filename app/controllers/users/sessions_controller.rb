class Users::SessionsController < ApplicationController
  before_action :redirect_authenticated_to_root, only: [:show]
  def new
  end

  def destroy
    # TODO
  end

  private

  def redirect_authenticated_to_root
    redirect_to filter_rules_path if user_signed_in?
  end
end
