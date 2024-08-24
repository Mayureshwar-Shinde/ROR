class CaseManagers::NotesController < ApplicationController
  def index
  	@case = Case.find(params[:case_id])
  	@notes = @case.notes.order(:created_at)
  end

  def new
  	@case = Case.find(params[:case_id])
  	@note = @case.notes.new
  end

  def create
  	@case = Case.find(params[:case_id])
  	@note = @case.notes.new
  	@note.content = params[:note][:content]
  	@note.user = current_case_manager

  	if @note.save
      redirect_to case_managers_case_notes_path(@case), notice: 'Note added successfully!'
    else
      @errors = @note.errors.full_messages.to_sentence
      redirect_to new_case_managers_case_note_path(@case), alert: @errors
    end
  end

  def edit
  	@case = Case.find(params[:case_id])
  	@note = @case.notes.find(params[:id])
  end

  def update
  	@case = Case.find(params[:case_id])
  	@note = @case.notes.find(params[:id])
  	@note.content = params[:note][:content]

  	if @note.save
      redirect_to case_managers_case_notes_path(@case), notice: 'Note updated successfully!'
    else
      @errors = @note.errors.full_messages.to_sentence
      redirect_to new_case_managers_case_note_path(@case), alert: @errors
    end
  end

  def destroy
  	@case = Case.find(params[:case_id])
  	@note = @case.notes.find(params[:id])
    if @note.delete
      redirect_to case_managers_case_notes_path(@case), notice: 'Note deleted successfully!'
    else
      redirect_to case_managers_case_notes_path(@case), alert: 'Note not deleted!'
    end
  end

end