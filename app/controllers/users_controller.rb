class UsersController < AuthenticatedController
  def index
    @users = current_organization.users.order(created_at: :desc)
  end

  def html_title
    super + " - Users"
  end

  private

  def current_organization
    current_user.organization
  end
end
