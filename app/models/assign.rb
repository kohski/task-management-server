# frozen_string_literal: true

class Assign < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :jobs

  def self.assign_existing?(assign_params)
    result = where(group_id: assign_params[:group_id]).where(user_id: assign_params[:user_id])
    !result.empty? ? result : false
  end
end
