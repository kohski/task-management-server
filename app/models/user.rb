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

  has_many :assigns, dependent: :destroy
  has_many :groups, dependent: :destroy, foreign_key: :owner_id
end
