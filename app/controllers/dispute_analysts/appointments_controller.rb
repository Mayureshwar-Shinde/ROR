class DisputeAnalysts::AppointmentsController < ApplicationController
  after_action :send_case_appointment_schedule_email, only: [:create]

  def create
    @appointment = Appointment.new(appointment_params)
    if @appointment.save
      redirect_to dispute_analysts_case_path(params[:case_id]), notice: 'Appointment scheduled successfully!'
    else
      @errors = @appointment.errors.full_messages.to_sentence
      redirect_to dispute_analysts_case_appointments_path, alert: @errors
    end
  end

  def index
    @appointments = Appointment.where(case_id: params[:case_id])
  end

  def my_appointments
    @appointments = Appointment.where("scheduler_id = ? OR schedulee_id = ?", current_dispute_analyst.id, current_dispute_analyst.id)
  end

  private

  def appointment_params
    params.require(:appointment).permit(%i[date start_time end_time status case_id scheduler_id schedulee_id])
  end

  def send_case_appointment_schedule_email
    UserMailer.case_appointment_schedule_email(@appointment).deliver_now
  end
  
end