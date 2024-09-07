class AvatarsController < ApplicationController

  def new
    @user = current_user
  end

  def create
    if params[:user].nil?
      flash[:error] = ['Please select an image']
      redirect_to new_avatar_path
      return
    end
    if current_user.avatar.attach(params[:user][:avatar])
      redirect_to new_avatar_path, notice: 'Avatar updated successfully!'
    else
      flash[:error] = current_user.errors.full_messages
      redirect_to new_avatar_path
    end
  end

  def destroy
    if current_user.avatar.attached?
      current_user.avatar.purge
      redirect_to new_avatar_path, notice: 'Avatar deleted successfully!'
    else
      flash[:error] = ['Please set a avatar first']
      redirect_to new_avatar_path
    end
  end

end
