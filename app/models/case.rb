class Case < ApplicationRecord
  belongs_to :user
  belongs_to :assigned_to, class_name: 'User', optional: true

  enum status: { open: 0, in_progress: 1, resolved: 2, closed: 3 }

  validates :case_number, presence: true, uniqueness: true
  validates :title, :description, :user_id, presence: true
  validates :status, inclusion: { in: [nil, 'open', 'in_progress', 'resolved', 'closed'] }

  after_validation :generate_case_number, on: :create

  has_many :notes

  has_many :appointments

  private

  def generate_case_number
    self.case_number = "##{SecureRandom.hex(3).upcase}"
  end

end
