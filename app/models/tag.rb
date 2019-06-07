# frozen_string_literal: true

class Tag < ApplicationRecord
  validates :name, presence: true, length: { maximum: 256 }

  has_many :job_tag
  has_many :job_tag_jobs, through: :job_tags, source: :job
end
