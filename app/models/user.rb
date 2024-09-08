class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :age, :date_of_birth, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :age, numericality: { only_integer: true, greater_than: 0 }
  validate :date_validation

  # adding avatar
  has_one_attached :avatar
  validates :avatar, presence: true, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], 
                                             dimension: { width: { min: 40, max: 600 }, height: { min: 40, max: 200 }, message: 'is not given between dimension' },
                                             size_range: 1..(5.megabytes) }

  private

  def date_validation
    return if date_of_birth.nil? || date_of_birth < Date.today
    errors.add(:date_of_birth, 'must be in the past')
  end
end
