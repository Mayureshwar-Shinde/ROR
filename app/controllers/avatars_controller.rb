class AvatarsController < ApplicationController

  def new
  end

  def create
    if params[:user].nil?
      redirect_to new_avatar_path, alert: 'Please select a image'
      return
    end
    @avatar_param = params[:user][:avatar]
    if current_user.avatar.attach(@avatar_param)
      redirect_to new_avatar_path, notice: 'Avatar updated successfully!'
    else
      @errors = current_user.errors.full_messages.to_sentence
      redirect_to new_avatar_path, alert: @errors
    end
  end

  def destroy
    if current_user.avatar.attached?
      current_user.avatar.purge
      redirect_to new_avatar_path, notice: 'Avatar deleted successfully!'
    else
      redirect_to new_avatar_path, alert: 'Please set a avatar first'
    end
  end

end
