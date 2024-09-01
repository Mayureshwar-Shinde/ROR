class DisputeAnalysts::RegistrationsController < Devise::RegistrationsController

  def build_resource(params = {})
    resource = super
    resource.role_type = User.role_types[:dispute_analyst]
    resource
  end

  protected

  def update_resource(resource, params)
    return super if params["password"]&.present?
    resource.update_without_password(params.except("current_password"))
  end

end