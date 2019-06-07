# frozen_string_literal: true

class Group < ApplicationRecord
  after_create :auto_assign_owner

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :assigns, dependent: :destroy
  has_many :users, through: :assigns
  has_many :jobs
  has_many :steps, through: :jobs

  validates :name, presence: true, uniqueness: true

  def auto_assign_owner
    Assign.create(user_id: owner_id, group_id: id)
  end
end
