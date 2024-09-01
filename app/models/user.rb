class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  validates :avatar, content_type: ['image/png', 'image/jpeg', 'image/jpg'],
                                     size: { less_than: 10.megabytes , message: 'is too large' }

  validates :first_name, :last_name, :age, :date_of_birth, :email, :encrypted_password, presence: true
  validates :age, numericality: { only_integer: true, greater_than: 17 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :phone, presence: true, uniqueness: true
  validate :date_validation

  has_many :cases

  enum role_type: { case_manager: 1, dispute_analyst: 2 }
  enum status: { active: 1, suspended: 2 }

  has_many :notes

  has_many :appointments

  audited
  has_associated_audits

  private

  def date_validation
    return if date_of_birth.nil? || date_of_birth < Date.today
    errors.add(:date_of_birth, 'must be in the past')
  end

end
