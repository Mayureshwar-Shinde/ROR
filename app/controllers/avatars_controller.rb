class AvatarsController < ApplicationController
  def update
    if params[current_user.role_type.to_sym].nil?
      flash[:error] = ['No avatar provided!']
    elsif current_user.update(avatar_params)
      flash[:notice] = 'Avatar updated successfully!'
    else
      flash[:error] = current_user.errors.full_messages
    end
    redirect_to avatar_path
  end

  def destroy
    current_user.avatar.purge
    redirect_to edit_avatar_path, notice: 'Avatar deleted successfully!'
  end

  private

  def avatar_params
    params.require(current_user.role_type.to_sym).permit(:avatar)
  end
end

