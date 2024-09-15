class CaseManagers::AvatarsController < ApplicationController
  before_action :authenticate_case_manager!

  def update
    if params[:case_manager].nil?
      flash[:error] = ['No avatar provided!']
    elsif current_case_manager.update(avatar_params)
      flash[:notice] = 'Avatar updated successfully!'
    else
      flash[:error] = current_case_manager.errors.full_messages
    end
    redirect_to edit_case_managers_avatar_path
  end

  def destroy
    current_case_manager.avatar.purge
    redirect_to edit_case_managers_avatar_path, notice: 'Avatar deleted successfully!'
  end

  private

  def avatar_params
    params.require(:case_manager).permit(:avatar)
  end
end

