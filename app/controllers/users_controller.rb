class UsersController < AuthenticatedController
  def index
    @gmail_users = current_organization.gmail_users.includes(:user).order(:user_id)
  end

  def promotions
    gmail_user = current_organization.gmail_users.find(params[:gmail_user_id])

    if gmail_user.user
      redirect_to users_path, notice: "User #{gmail_user.email} can already create filter rules for everyone" and return
    end

    gmail_user.create_user!(email: gmail_user.email, organization: current_organization, provider: "google")

    redirect_to users_path, notice: "User #{gmail_user.email} can create filter rules for everyone now"
  end

  def html_title
    super + " - Users"
  end
end
