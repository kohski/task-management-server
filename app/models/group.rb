class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :assigns, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
