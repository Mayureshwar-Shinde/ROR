class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :generate_current_user_instance

  protected
  
  def configure_permitted_parameters
    permitted_params = %i[first_name last_name age date_of_birth phone email password password_confirmation]
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(permitted_params) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(permitted_params, :current_password) }
  end

  def authenticate_admin!
    token = Token.find_by(value: request.headers['Authorization'])
    if token.nil? || token.expired_at < Time.current
      render json: { error: 'Unauthorized access' }, status: :unauthorized
    end
  end

  def generate_current_user_instance
    @current_user = nil
    @user_signed_in = false
    @user_signed_in = true if case_manager_signed_in? || dispute_analyst_signed_in?
    @current_user = current_case_manager unless current_case_manager.nil?
    @current_user = current_dispute_analyst unless current_dispute_analyst.nil?
  end
end
