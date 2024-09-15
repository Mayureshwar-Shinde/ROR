class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_user, :user_signed_in?

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

  def current_user
    user = current_case_manager
    user = current_dispute_analyst if dispute_analyst_signed_in?
    user
  end

  def user_signed_in?
    !current_user.nil?
  end

  def authenticate_user!
    redirect_to root_path, alert: 'You need to signin or signup before continuing!' unless user_signed_in?
  end
end
