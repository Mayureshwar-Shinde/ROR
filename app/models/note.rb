class Note < ApplicationRecord
  belongs_to :case
  belongs_to :user

  validates :content, :user_id, :case_id, presence: true  
end
