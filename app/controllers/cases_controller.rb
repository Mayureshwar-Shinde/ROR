class CasesController < ApplicationController
  def new
    @case = Case.new
  end

  def create
    @case = current_user.cases.new(case_params)
    if @case.save
      redirect_to root_path, notice: 'Case created successfully!'
    else
      render :new, status: 422
    end
  end

  private

  def case_params
    params.require(:case).permit(:title, :description, :status, :user_id, :assigned_to_id)
  end
end
