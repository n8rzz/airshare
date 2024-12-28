class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  rescue_from OAuth2::Error, with: :handle_oauth_error

  def google_oauth2
    handle_auth("Google")
  end

  def failure
    redirect_to root_path, alert: "Authentication failed, please try again."
  end

  private

  def handle_auth(kind)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted? && @user.errors.empty?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      handle_auth_failure(kind)
    end
  end

  def handle_auth_failure(kind)
    if @user.errors[:email].include?('Email address is required')
      redirect_to new_user_registration_url, alert: 'Email address is required'
    else
      store_auth_data(kind)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def store_auth_data(kind)
    session["devise.#{kind.downcase}_data"] = request.env["omniauth.auth"].except(:extra)
  end

  def handle_oauth_error(exception)
    redirect_to new_user_session_path, 
                alert: "Authentication failed: #{exception.message}"
  end
end 