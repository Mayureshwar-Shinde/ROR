class CaseManagers::AvatarsController < ApplicationController

  def new
  end

  def create
    if params[:case_manager].nil?
      redirect_to case_managers_new_avatar_path, alert: 'Please select a image'
      return
    end
    @avatar_param = params[:case_manager][:avatar]
    if current_case_manager.avatar.attach(@avatar_param)
      redirect_to case_managers_new_avatar_path, notice: 'Avatar updated successfully!'
    else
      @errors = current_case_manager.errors.full_messages.to_sentence
      redirect_to case_managers_new_avatar_path, alert: @errors
    end
  end

  def destroy
    if current_case_manager.avatar.attached?
      current_case_manager.avatar.purge
      redirect_to case_managers_new_avatar_path, notice: 'Avatar deleted successfully!'
    else
      redirect_to case_managers_new_avatar_path, alert: 'Please set a avatar first'
    end
  end

end