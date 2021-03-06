module DeviseWhitelist
  extend ActiveSupport::Concern

  included do
    before_action :configure_permitted_parameters, if: :devise_controller?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :brief_about, :about, skills_attributes: [:id, :title, :percent_utilized, :_destroy], watches_attributes: [:id, :title, :amount, :status, :_destroy]])
  end
end
