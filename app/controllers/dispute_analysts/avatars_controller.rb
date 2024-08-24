class DisputeAnalysts::AvatarsController < ApplicationController

  def new
  end

  def create
    if params[:dispute_analyst].nil?
      redirect_to dispute_analysts_new_avatar_path, alert: 'Please select a image'
      return
    end
    @avatar_param = params[:dispute_analyst][:avatar]
    if current_dispute_analyst.avatar.attach(@avatar_param)
      redirect_to dispute_analysts_new_avatar_path, notice: 'Avatar updated successfully!'
    else
      @errors = current_dispute_analyst.errors.full_messages.to_sentence
      redirect_to dispute_analysts_new_avatar_path, alert: @errors
    end
  end

  def destroy
    if current_dispute_analyst.avatar.attached?
      current_dispute_analyst.avatar.purge
      redirect_to dispute_analysts_new_avatar_path, notice: 'Avatar deleted successfully!'
    else
      redirect_to dispute_analysts_new_avatar_path, alert: 'Please set a avatar first'
    end
  end

end