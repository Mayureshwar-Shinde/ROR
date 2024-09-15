class DisputeAnalysts::SessionsController < Devise::SessionsController
  before_action :ensure_dispute_analyst, only: [:create]

  def ensure_dispute_analyst
    user = User.find_by(email: params[:dispute_analyst][:email])
    if user && !user.dispute_analyst?
      session.destroy
      redirect_to new_dispute_analyst_session_path, alert: 'Unauthorized access as a Dispute Analyst.'
    end
  end
end