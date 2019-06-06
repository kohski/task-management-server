# frozen_string_literal: true

class User < ActiveRecord::Base
  # mount_uploader :image, PhotoUploader
  mount_base64_uploader :image, PhotoUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
        #  :trackable,
        :validatable
  include DeviseTokenAuth::Concerns::User

  validates :name, presence: true, length: { maximum: 64 }
  validates :email, presence: true, uniqueness: true, format:{with:/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :admin, presence: true, default: false
  validates :description, length:{ maximum: 1000 }

  has_many :assigns, dependent: :destroy
  has_many :groups, dependent: :destroy, foreign_key: :owner_id
end
