class DisputeAnalysts::CasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_case, only: %i[show edit update]

  def index
    @cases = Case.where(assigned_to: current_dispute_analyst).paginate(page: params[:page], per_page: 10)
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
      redirect_to dispute_analysts_case_path, notice: "Case updated successfully"
    else
      render :edit, status: 422
    end
  end

  private

  def case_params
    params.require(:case).permit(:status)
  end

  def set_case
    @case = Case.find(params[:id])
  end

end
