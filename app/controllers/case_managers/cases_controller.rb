class CaseManagers::CasesController < ApplicationController

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
    @cases = @cases.where(status: params[:status][:status]) if params[:status].present? && !(params[:status][:status]).empty?
    if params[:sort] == 'first_name'
      @cases = @cases.select("cases.*, users.first_name").joins(:user)
      @cases = @cases.order(params[:sort])
    elsif params[:sort] == 'assigned_to'
      @cases = @cases.select("cases.*, users.first_name").joins("LEFT JOIN users ON cases.assigned_to_id = users.id")
      @cases = @cases.order(:first_name)
    elsif params[:sort] == 'created_at' || params[:sort] == 'updated_at'
      @cases = @cases = @cases.all.order("#{params[:sort]} DESC")
    else
      @cases = @cases.all.order(params[:sort])
    end
  end

  def show
    @case = Case.find(params[:id])
  end

  def edit
    @case = Case.find(params[:id])
    @users = User.where(role_type: 'dispute_analyst')
  end

  def update
    @case = Case.find(params[:id])
    @case.resolved_by_id = @case.user_id if params[:case][:status] == 'resolved'
    if @case.update(case_params)
      redirect_to case_managers_cases_path, notice: "Case updated successfully"
    else
      @errors = @case.errors.full_messages.to_sentence
      redirect_to edit_case_managers_case_path, alert: @errors
    end
  end

  def destroy
  end

  private

  def case_params
    params.require(:case).permit(:title, :description, :status, :user_id, :assigned_to_id, :resolved_by_id)
  end

end
