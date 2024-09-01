class DisputeAnalysts::SessionsController < Devise::SessionsController
  before_action :ensure_dispute_analyst, only: [:create]
  after_action :send_welcome_email, only: [:create]

  def send_welcome_email
    UserMailer.with(user: current_dispute_analyst).welcome_email.deliver_now
  end

  def ensure_dispute_analyst
    user = User.find_by(email: params[:dispute_analyst][:email])
    if user && !user.dispute_analyst?
      session.destroy
      redirect_to new_dispute_analyst_session_path, alert: 'Unauthorized access as a Dispute Analyst.'
    end
  end
end