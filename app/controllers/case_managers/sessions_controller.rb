class CaseManagers::SessionsController < Devise::SessionsController
  before_action :ensure_case_manager, only: [:create]
  after_action :send_welcome_email, only: [:create]

  def send_welcome_email
    UserMailer.with(user: current_case_manager).welcome_email.deliver_now
  end

  def ensure_case_manager
    user = User.find_by(email: params[:case_manager][:email])
    if user && !user.case_manager?
      session.destroy
      redirect_to new_case_manager_session_path, alert: 'Unauthorized access as a Case Manager'
    end
  end
end