class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :age, :date_of_birth, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :age, numericality: { only_integer: true, greater_than: 0 }
  validate :date_validation

  has_one_attached :avatar

  validates :avatar, content_type: %w[ image/png image/jpeg image/jpg ],
                                    # dimension: { width: { min: 40, max: 1600 },
                                    #               height: { min: 40, max: 1200 }, message: 'is not given between dimensions (1200 x 1600)' },
                                    size: { less_than: 10.megabytes, 
                                            message: 'size should be less than 10mb' }

  has_many :cases, dependent: :destroy

  enum :role_type, {:case_manager=>1, :dispute_analyst=>2}
  enum :status, {:active=>1, :suspended=>2}

  private

  def date_validation
    return if date_of_birth.nil? || date_of_birth < Date.today
    errors.add(:date_of_birth, 'must be in the past')
  end
end