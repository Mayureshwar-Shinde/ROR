class AvatarsController < ApplicationController
  before_action :authenticate_user!

  def update
    if params[:user].nil?
      flash[:error] = ['No avatar provided!']
    elsif current_user.update(avatar_params)
      notice = 'Avatar updated successfully!'
    else
      flash[:error] = current_user.errors.full_messages
    end
    redirect_to edit_avatar_path, notice:
  end

  def destroy
    current_user.avatar.purge
    redirect_to edit_avatar_path, notice: 'Avatar deleted successfully!'
  end

  private

  def avatar_params
    params.require(:user).permit(:avatar)
  end
end