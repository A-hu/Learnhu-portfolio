class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # https://github.com/rails-camp/facebook-omniauth-demo
  # https://www.crondose.com/2016/12/guide-integrating-omniauth-rails-5-facebook-login-feature/
  # https://github.com/ihower/rails-exercise-ac5/commit/291c813d6f5e35d38325ed03be15652e5fdd2104
  # https://github.com/ihower/rails-exercise-ac5/commit/6d1deca09ca7c1b1026d18e1181568cc1926511b

  before_action -> { check_feature(request.env["omniauth.auth"]) }, only: [:facebook]

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @user.skip_confirmation!

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url, notice: "#{@user.provider.upcase} does not provide some features, please register an account"
    end
  end

  def failure
    redirect_to root_path
  end

  def check_feature auth
    if auth.info.email == nil || auth.info.name == nil
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url, notice: "#{auth.provider.upcase} does not provide some features, please register an account"
    end
  end
end
