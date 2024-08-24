class CasesController < ApplicationController

  def new
    @case = Case.new
  end

  def create
    @case = Case.new(case_params)
    @case.user = current_user
    if @case.save
      redirect_to root_path, notice: "Case created successfully"
    else
      @errors = @case.errors.full_messages.to_sentence
      redirect_to new_case_path, alert: @errors
    end
  end

  def index
  end

  private

  def case_params
    params.require(:case).permit(:title, :description, :status, :assigned_to_id)
  end

end
