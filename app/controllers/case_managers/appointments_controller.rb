class CaseManagers::AppointmentsController < ApplicationController

  def create
    @appointment = Appointment.new(appointment_params)
    if @appointment.save
      redirect_to case_managers_case_path(params[:case_id]), notice: 'Appointment scheduled successfully!'
    else
      @errors = @appointment.errors.full_messages.to_sentence
      redirect_to case_managers_case_appointments_path, alert: @errors
    end
  end

  def index
    @appointments = Appointment.where(case_id: params[:case_id])
  end

  def edit
    @appointment = Appointment.find(params[:id])
    @case = Case.find(params[:case_id])
  end

  def update
    @appointment = Appointment.find(params[:id])
    if @appointment.update(appointment_params)
      redirect_to case_managers_case_appointments_path(@appointment.case), notice: 'Appointment updated successfully!'
    else
      @errors = @appointment.errors.full_messages.to_sentence
      redirect_to edit_case_managers_case_appointment_path(case_id:@appointment.case, id:@appointment), alert: @errors
    end
  end

  def my_appointments
    @appointments = Appointment.where("scheduler_id = ? OR schedulee_id = ?", current_case_manager.id, current_case_manager.id)
  end

  private

  def appointment_params
    params.require(:appointment).permit(%i[date start_time end_time status case_id scheduler_id schedulee_id])
  end
end


  # def appointments
  #   @appointments = Appointment.where("scheduler_id = ? OR schedulee_id = ?", current_case_manager.id, current_case_manager.id)
  # end