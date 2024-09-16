class CaseManagers::CasesController < ApplicationController
  before_action :authenticate_case_manager!
  before_action :set_dispute_analysts, only: %i[edit update]
  before_action :set_case, only: %i[show edit update]

  def new
    @case = current_case_manager.cases.new
  end

  def create
    @case = current_case_manager.cases.new(case_params)
    if @case.save
      redirect_to root_path, notice: 'Case created successfully'
    else
      render :new, status: 422
    end
  end

  def index
    @cases = Case.paginate(page: params[:page], per_page: 10)
    @cases = @cases.where(status: params[:filter][:status]) if params[:filter].present? && !(params[:filter][:status]).empty?
    if params[:sort] == 'first_name'
      @cases = @cases.includes(:user).order('users.first_name')
    elsif params[:sort] == 'assigned_to'
      @cases = @cases.includes(:assigned_to).order('users.first_name')
    elsif params[:sort] == 'created_at' || params[:sort] == 'updated_at'
      @cases = @cases.order("#{params[:sort]} DESC")
    else
      @cases = @cases.order(params[:sort])
    end
  end

  def update
    if @case.update(case_params)
      redirect_to case_managers_case_path, notice: "Case updated successfully"
    else
      render :edit, status: 422
    end
  end

  private

  def case_params
    params.require(:case).permit(:title, :description, :status, :assigned_to_id)
  end

  def set_dispute_analysts
    @users = User.where(role_type: 'dispute_analyst')
  end

  def set_case
    @case = Case.find(params[:id])
  end

end
