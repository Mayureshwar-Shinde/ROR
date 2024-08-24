class DisputeAnalysts::CasesController < ApplicationController

  def create
    @case = current_dispute_analyst.cases.new(case_params)
    if @case.save
      redirect_to root_path, notice: "Case created successfully"
    else
      @errors = @case.errors.full_messages.to_sentence
      redirect_to new_dispute_analysts_case_path, alert: @errors
    end
  end

  def index
    @cases = Case.paginate(page: params[:page], per_page: 10).where(assigned_to_id: current_dispute_analyst.id)
  end

  def show
    @case = Case.find(params[:id])
  end

  def edit
    @case = Case.find(params[:id])
  end

  def update
    @case = Case.find(params[:id])
    @case.resolved_by_id = @case.user_id if params[:case][:status] == 'resolved'
    if @case.update(case_params)
      redirect_to dispute_analysts_cases_path, notice: "Case updated successfully"
    else
      @errors = @case.errors.full_messages.to_sentence
      redirect_to edit_dispute_analysts_case_path, alert: @errors
    end
  end

  def destroy
  end

  private

  def case_params
    params.require(:case).permit(:title, :description, :status, :user_id, :assigned_to_id, :resolved_by_id)
  end

end
