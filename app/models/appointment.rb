class Appointment < ApplicationRecord
  belongs_to :case
  belongs_to :scheduler, class_name: 'User'
  belongs_to :schedulee, class_name: 'User'

  validates :date, :start_time, :end_time, presence: true
  validates :case_id, presence: true, numericality: { only_integer: true }
  validates :scheduler_id, :schedulee_id, presence: true, numericality: { only_integer: true }
  validates :status, presence: true, inclusion: { in: %w[scheduled cancelled completed] }

  # validate :valid_time_range

  private

  def valid_time_range
    return if date.nil? || start_time.nil? || end_time.nil?
    errors.add(:date, "must be in the future") if date < Date.today
    errors.add(:start_time, "can't be in the past") if date == Date.today && start_time < DateTime.current 
    errors.add(:end_time, "can't be before start time") if end_time < start_time
  end

end
