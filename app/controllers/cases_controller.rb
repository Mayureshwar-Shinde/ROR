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

  private

  def case_params
    params.require(:case).permit(:title, :description, :status, :assigned_to_id, :user_id)
  end

end
