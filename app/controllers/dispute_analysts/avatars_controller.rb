class DisputeAnalysts::AvatarsController < ApplicationController
  before_action :authenticate_dispute_analyst!

  def update
    if params[:dispute_analyst].nil?
      flash[:error] = ['No avatar provided!']
    elsif current_dispute_analyst.update(avatar_params)
      flash[:notice] = 'Avatar updated successfully!'
    else
      flash[:error] = current_dispute_analyst.errors.full_messages
    end
    redirect_to edit_dispute_analysts_avatar_path
  end

  def destroy
    current_dispute_analyst.avatar.purge
    redirect_to edit_dispute_analysts_avatar_path, notice: 'Avatar deleted successfully!'
  end

  private

  def avatar_params
    params.require(:dispute_analyst).permit(:avatar)
  end

end