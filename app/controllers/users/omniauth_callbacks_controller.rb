class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.from_google(from_google_params)

    if user.present?
      sign_out_all_scopes
      # flash[:notice] = t "devise.omniauth_callbacks.success", kind: "Google"
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = t "devise.omniauth_callbacks.failure", kind: "Google", reason: "#{auth.info.email} is not authorized."
      redirect_to new_users_session_path
    end
  end

  def slack
    unless current_user
      redirect_to new_users_session_path, notice: "Sign in required"
    end
    current_user.organization.update(slack_webhook_url: auth.extra.raw_info.web_hook_info.url)
    redirect_to current_user.organization, notice: "Slack notifications configured"
  end

  private

  def from_google_params
    @from_google_params ||= {
      uid: auth.uid,
      email: auth.info.email
    }
  end

  def auth
    @auth ||= request.env["omniauth.auth"]
  end

  def after_omniauth_failure_path_for(_scope)
    new_users_session_path
  end
end
