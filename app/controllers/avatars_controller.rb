class AvatarsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    if params[:user].nil?
      flash[:error] = ['No avatar provided!']
      return redirect_to edit_avatar_path
    end
    @user = current_user
    if @user.update(avatar_params)
      redirect_to edit_avatar_path, notice: 'Avatar updated successfully.'
    else
      flash[:error] = current_user.errors.full_messages
      redirect_to edit_avatar_path
    end
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
