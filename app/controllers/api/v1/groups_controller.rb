class Api::V1::GroupsController < ApplicationController
  before_action :authenticate_user!	

  def show
    group = Group.find_by(id: params[:id])
    # after making assign model, will make access restriction. only owner and user can access this info,
    # if not either owner or team mate return error message.
    render json: {
      status: "SUCCESS",
      data: group
    }
  end

  def create
    group = current_user.groups.build(group_params)
    if group.save
      render json: {
        status: "SUCCESS",
        data: group
      }
    else
      render json: {
        status: "ERROR",
        data: group.errors.full_messages
      }
    end
  end

  def destroy
    group = Group.find_by(id: params[:id])
    begin
      group.destroy
      render json: {
        status: "SUCCESS",
      }
    rescue
      render json:{
        status: "ERROR",
        data: "ERROR has occured"
      }
    end
  end

  def update
    group = Group.find_by(id: params[:id])
    if group.update(group_params)
      render json: {
        status: "SUCCESS",
        data: group
      }
    else
      render json: {
        status: "ERROR",
        data: group.errors.full_messages
      }
    end
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

end
