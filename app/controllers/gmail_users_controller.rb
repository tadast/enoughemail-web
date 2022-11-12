class GmailUsersController < AuthenticatedController
  def index
    @gmail_users = current_organization.gmail_users.includes(:user).order(:email)
  end

  def html_title
    super + " - Gmail Users"
  end

  private

  def current_organization
    current_user.organization
  end
end
