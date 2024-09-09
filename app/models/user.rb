class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :age, :date_of_birth, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :age, numericality: { only_integer: true, greater_than: 0 }
  validate :date_validation

  # adding avatar
  has_one_attached :avatar
  validates :avatar, content_type: ['image/png', 'image/jpeg', 'image/jpg'],
                                    # dimension: { width: { min: 40, max: 1600 },
                                                  # height: { min: 40, max: 1200 }, message: 'is not given between dimension' },
                                    size: { less_than: 10.megabytes , message: 'is too large' }

  private

  def date_validation
    return if date_of_birth.nil? || date_of_birth < Date.today
    errors.add(:date_of_birth, 'must be in the past')
  end
end
