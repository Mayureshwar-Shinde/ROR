class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :age, :date_of_birth, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :password, length: { minimum: 6 }
  validates :age, numericality: { only_integer: true, greater_than: 0 }
  validate :date_validation

  private

  def date_validation
    return if date_of_birth.nil? || date_of_birth < Date.today
    errors.add(:date_of_birth, 'must be in the past')
  end
end
