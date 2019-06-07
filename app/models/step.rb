# frozen_string_literal: true

class Step < ApplicationRecord
  validates :content, presence: true, length: { maximum: 256 }
  validates :assigned_user, in_group_member: true
  # validates :image,
  # validates :due_date
  validates :is_done, default: false
  validates :is_approved, default: false
  validates :order, numericality: { only_integer: true }
  belongs_to :job, foreign_key: 'job_id'
end
