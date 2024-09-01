class CaseManagers::CasesController < ApplicationController
  before_action :authenticate_case_manager!
  after_action :send_case_update_email, only: [:update]

  def new
    @case = current_case_manager.cases.new
  end

  def create
    @case = current_case_manager.cases.new(case_params)
    if @case.save
      redirect_to root_path, notice: "Case created successfully"
    else
      @errors = @case.errors.full_messages.to_sentence
      redirect_to new_case_managers_case_path, alert: @errors
    end
  end

  def index
    @cases =  Case.paginate(page: params[:page], per_page: 10)
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
      redirect_to case_managers_case_path, notice: "Case updated successfully"
    else
      @errors = @case.errors.full_messages.to_sentence
      redirect_to edit_case_managers_case_path, alert: @errors
    end
  end

  def audit
    @case_manager_audits = current_case_manager.audits
    @cases_audits = current_case_manager.cases.map(&:audits).flatten
    @associated_audits = current_case_manager.associated_audits
    @own_and_associated_audits = current_case_manager.own_and_associated_audits
  end

  private

  def case_params
    params.require(:case).permit(:title, :description, :status, :user_id, :assigned_to_id)
  end

  def send_case_update_email
    @case = Case.find(@old_case.id)
    @changes = []
    changer_name = 
    if @case.status != @old_case.status
      @changes.push("Case status changed from '#{@old_case.status.capitalize}' to '#{@case.status.capitalize}'.")
    end
    if @case.assigned_to_id != @old_case.assigned_to_id
      @changes.push("Case is now assigned to '#{@case.assigned_to.first_name} #{@case.assigned_to.last_name}'.")
    end
    if @case.title != @old_case.title
      @changes.push("Case title changed from '#{@old_case.title}' to '#{@case.title}'.")
    end
    if @case.description != @old_case.description
      @changes.push("Case description has been modified.")
    end
    @details = {
      case_number: @case.case_number,
      to: @case.assigned_to.email,
      updater: "#{current_case_manager.first_name} #{current_case_manager.last_name}"
    }
    UserMailer.case_update_email(@details, @changes).deliver_now
  end

end
