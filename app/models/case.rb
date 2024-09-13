class Case < ApplicationRecord
  belongs_to :user
  belongs_to :assigned_to, class_name: 'User', foreign_key: 'assigned_to_id', optional: true

  enum :status, %i[ open in_progress resolved closed ]

  validates :case_number, uniqueness: true
  validates :title, :description, presence: true
  validates_presence_of :user

  before_validation :generate_case_number, on: :create

  private

  def generate_case_number
    self.case_number = "##{SecureRandom.hex(3).upcase}"
  end
end
