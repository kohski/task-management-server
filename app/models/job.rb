class Job < ApplicationRecord
  enum frequency: { no_repeat: 0, daily: 1, weekly: 2, monthly: 3, yearly: 4 }

  validates :title, presence: true, length: { maximum: 256}
  validates :owner_id, in_group_member: true
  validates :overview, length: { maximum: 512}
  # validates :image, 
  # validates :base_date_time
  validates :due_date_time, is_future_date: true
  # validates :frequency
  validates :is_done, default: false
  validates :is_approved, default: false

  belongs_to :group, class_name: 'Group', foreign_key: :group_id
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  
  has_many :steps, dependent: :destroy
end
