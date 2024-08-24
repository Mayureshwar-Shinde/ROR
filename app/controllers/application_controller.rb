class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :generate_current_user_instance

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :age, :date_of_birth, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :age, :date_of_birth, :email, :password, :password_confirmation, :current_password) }
  end

  private

  def authenticate_admin!
    token_value = request.headers['Authorization']

    if token_value.blank?
      render json: { error: 'Unauthorized: No token provided' }, status: :unauthorized
      return
    end

    token = Token.find_by(value: token_value)

    if token.nil? || token.expired_at < Time.current
      render json: { error: 'Unauthorized: Invalid or expired token' }, status: :unauthorized
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
