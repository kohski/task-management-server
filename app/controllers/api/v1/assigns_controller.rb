# frozen_string_literal: true

class Api::V1::AssignsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def create
    already_exist = Assign.assign_existing?(assign_params)

    if already_exist
      response_success(already_exist[0].attributes)
      return
    end

    group = Group.find_by(id: assign_params[:group_id])
    unless group
      response_not_found(group)
      return
    end

    user = User.find_by(id: assign_params[:user_id])
    unless user
      response_not_found(user)
      return
    end

    assign = group.assigns.build(assign_params)
    if assign.save
      response_created(assign)
    else
      response_bad_request(assign.errors.full_messages)
    end
  end

  def destroy
    assign = Assign.find_by(id: params[:id])
    begin
      assign.destroy
      response_success(assign)
    rescue StandardError => exception
      response_bad_request(assign)
    end
  end

  def assign_params
    params.require(:assign).permit(:user_id, :group_id)
  end
end
