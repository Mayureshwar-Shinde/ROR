class DisputeAnalysts::CommunicationsController < ApplicationController

  def new
  	@communication = Communication.new
    @case = Case.find(params[:id])
    @message_type = params[:message_type]
  end

  def create
  	@communication = Communication.new(communication_params)
    if @communication.save
      if @communication.message_type == 'email'
        UserMailer.case_email(@communication).deliver_now
      elsif @communication.message_type == 'sms'
        Twilio::SmsService.new.case_sms(@communication)
      end
      redirect_to dispute_analysts_case_path(params[:id]), notice: 'Communication sent successfully'
    else
      @errors = @communication.errors.full_messages.to_sentence
      redirect_to new_dispute_analysts_communication_path(message_type: @message_type), alert: @errors
    end
  end

  def index
  	@communications = Communication.all
  end

  private

  def communication_params
  	params.require(:communication).permit(:subject, :message, :message_type, :from_id, :to_id, :case_id)
  end

end
