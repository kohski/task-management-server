class Job < ApplicationRecord
  validates :title, presence: true, length: { maximum: 256}
  validates :owner_id, job: true
  belongs_to :group, foreign_key: :group_id
end
