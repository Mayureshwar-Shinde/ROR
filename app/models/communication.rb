class Communication < ApplicationRecord
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'
  belongs_to :case, class_name: 'Case'

  validates :from, :to, :message, :message_type, presence: true
  validates :subject, presence: true, length: { maximum: 255 }
  validates :case, presence: true

  audited associated_with: :from
end
