class DisputeAnalysts::CasesController < ApplicationController
  after_action :send_case_update_email, only: [:update]

  def index
    @cases =  Case.where(assigned_to_id: current_dispute_analyst.id).paginate(page: params[:page], per_page: 10)
    if params[:filter].present?
      @cases = @cases.where(status: params[:filter][:status]) unless params[:filter][:status].empty?
      @cases = @cases.where(case_number: params[:filter][:case_number]) unless params[:filter][:case_number].empty?
    end

    if params[:sort] == 'first_name'
      @cases = @cases.includes(:user).order("users.first_name")
    elsif params[:sort] == 'assigned_to'
      @cases = @cases.includes(:assigned_to).order("users.first_name")
    elsif params[:sort] == 'created_at' || params[:sort] == 'updated_at'
      @cases = @cases.order("#{params[:sort]} DESC")
    else
      @cases = @cases.order(params[:sort])
    end
  end

  def show
    @case = Case.find(params[:id])
    @appointment = Appointment.new
  end

  def edit
    @case = Case.find(params[:id])
    @users = User.where(role_type: 'dispute_analyst')
  end

  def update
    @case = Case.find(params[:id])
    @old_case = Case.find(params[:id])
    if @case.update(case_params)
      redirect_to dispute_analysts_case_path, notice: "Case updated successfully"
    else
      @errors = @case.errors.full_messages.to_sentence
      redirect_to edit_dispute_analysts_case_path, alert: @errors
    end
  end

  private

  def case_params
    params.require(:case).permit(:title, :description, :status, :user_id, :assigned_to_id)
  end

  def send_case_update_email
    @case = Case.find(@old_case.id)
    @changes = []
    changer_name = "#{current_dispute_analyst.first_name} #{current_dispute_analyst.last_name}"
    if @case.status != @old_case.status
      @changes.push("Case status changed from '#{@old_case.status.capitalize}' to '#{@case.status.capitalize}'.")
    end
    @details = {
      case_number: @case.case_number,
      to: @case.user.email,
      updater: "#{current_dispute_analyst.first_name} #{current_dispute_analyst.last_name}"
    }
    UserMailer.case_update_email(@details, @changes).deliver_now
  end

end
