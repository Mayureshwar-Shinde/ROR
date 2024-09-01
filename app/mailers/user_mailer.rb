class UserMailer < ApplicationMailer
  default from: 'system@casewise.com'
  def welcome_email
    @user = params[:user]
  	mail(to: @user.email, subject: "Welcome email") unless @user.nil?
  end

  # send email manually from case profile page
  def case_email(communication)
    @body = communication.message
    from = communication.from.email
    to = communication.to.email
    subject = communication.subject
    mail(from: from, to: communication.to.email, subject: subject) unless communication.nil?
  end

  # send automatically when case is updated
  def case_update_email(details, changes)
    @details = details
    @changes = changes
    subject = "Case #{details[:case_number]} Update"
    mail(to: details[:to], subject: subject)
  end

  # send automatically when new appointment is scheduled
  def case_appointment_schedule_email(appointment)
    @appointment = appointment
    subject = " Appointment Scheduled for Case #{appointment.case.case_number}"
    mail(to: appointment.schedulee.email, subject: subject)
  end

  # send automatically when appointment is updated
  def case_appointment_update_email(appointment, changes, changer_name)
    @changes = changes
    @appointment = appointment
    @changer_name = changer_name
    subject = "Appointment Updated for Case #{appointment.case.case_number}"
    mail(to: appointment.schedulee.email, subject: subject)
  end

end
