class DeleteUser < ActiveInteraction::Base
  object :user, class: User

  def execute
    errors.merge!(user.errors) unless user.destroy
    user
  end
end
