class CaseManagers::AppointmentsController < ApplicationController
  after_action :send_case_appointment_schedule_email, only: [:create]
  after_action :send_case_appointment_update_email, only: [:update]

  def create
    @appointment = Appointment.new(appointment_params)
    debugger
    if @appointment.save
      debugger
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
    @old_appointment = Appointment.find(params[:id])
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

  def send_case_appointment_schedule_email
    UserMailer.case_appointment_schedule_email(@appointment).deliver_now
  end

  def send_case_appointment_update_email
    @changes = []
    changer_name = "#{current_case_manager.first_name} #{current_case_manager.last_name}"
    unless @appointment.start_time == @old_appointment.start_time
      @changes.push("Changed the Appointment start time from '#{@old_appointment.start_time.strftime("%l:%M%P")}' to '#{@appointment.start_time.strftime("%l:%M%P")}'")
    end
    unless @appointment.end_time == @old_appointment.end_time
      @changes.push("Changed the Appointment end time from '#{@old_appointment.end_time.strftime("%l:%M%P")}' to '#{@appointment.end_time.strftime("%l:%M%P")}'")
    end
    unless @appointment.status == @old_appointment.status
      @changes.push("Changed the Appointment status from '#{@old_appointment.status.capitalize}' to '#{@appointment.status.capitalize}'")
    end
    UserMailer.case_appointment_update_email(@appointment, @changes, changer_name).deliver_now
  end

end
