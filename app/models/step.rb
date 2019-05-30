class Step < ApplicationRecord
  validates :name, presence: true, length: { maximum: 256 }
  validates :assigned_user, in_group_member: true
  # validates :image,
  # validates :due_date
  validates :is_done, presence: true, default: false
  validates :is_approved, presence: true, default: false
  validates :order, numericality: { only_integer: true }
  belongs_to :job, foreign_key: "job_id"
end
