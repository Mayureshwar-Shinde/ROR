class CasesController < ApplicationController
  before_action :authenticate_case_manager!, only: %i[new create]

  def new
    @case = Case.new
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
    if case_manager_signed_in?
      @cases = Case.paginate(page: params[:page], per_page: 10)
    elsif dispute_analyst_signed_in?
      @cases = Case.where(assigned_to: current_dispute_analyst).paginate(page: params[:page], per_page: 10)
    else
      return redirect_to root_path, alert: 'You need to singin or signup before continuing!'
    end
      @cases = @cases.where(status: params[:filter][:status]) if params[:filter].present? && !(params[:filter][:status]).empty?
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

  private

  def case_params
    params.require(:case).permit(:title, :description, :status, :assigned_to_id, :user_id)
  end

end
