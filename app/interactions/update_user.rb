class UpdateUser < ActiveInteraction::Base
  object :user, class: User
  string :first_name, default: nil
  string :last_name, default: nil
  integer :age, default: nil
  date :date_of_birth, default: nil
  string :email, default: nil
  string :password, default: nil

  validates :email, presence: true, allow_nil: true
  validates :password, length: { minimum: 6 }, allow_nil: true

  def execute
    user.assign_attributes(
      first_name: first_name || user.first_name,
      last_name: last_name || user.last_name,
      age: age || user.age,
      date_of_birth: date_of_birth || user.date_of_birth,
      email: email || user.email,
      password: password || user.password
    )
    errors.merge!(user.errors) unless user.save
    user
  end
end
