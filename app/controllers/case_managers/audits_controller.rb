class CaseManagers::AuditsController < ApplicationController
  def index
    @types = %w[user case note appointment communication]
  end

  def show
    # @user_audits = current_case_manager.associated_audits.where(auditable_type: 'Note')
    @type = params[:type]
    if @type == 'user'
      @audits = current_case_manager.audits
    else
      @audits = current_case_manager.associated_audits.where(auditable_type: @type.capitalize)
    end
  end

  def show_avatars
  end

  def show_cases
  end

  def show_notes
  end

  def show_appointments
  end

  def show_communication
  end
end
