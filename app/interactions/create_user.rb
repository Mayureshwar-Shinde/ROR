class CreateUser < ActiveInteraction::Base
  string :first_name
  string :last_name
  integer :age
  date :date_of_birth
  string :email
  string :password

  validates :email, presence: true
  validates :password, presence: true, length: { minimum: 6 }

  def execute
    user = User.new(
      first_name:,
      last_name:,
      age:,
      date_of_birth:,
      email:,
      password:
    )

    errors.merge!(user.errors) unless user.save
    user
  end
end
