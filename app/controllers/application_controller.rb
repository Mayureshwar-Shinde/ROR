class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    permitted_params = [:first_name, :last_name, :age, :date_of_birth, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(permitted_params) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(permitted_params) }
  end
end
