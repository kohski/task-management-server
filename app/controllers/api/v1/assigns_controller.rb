class Api::V1::AssignsController < ApplicationController

  def create
    group   = Group.find_by(id: assign_params[:group_id]);
    assign = group.assigns.build(assign_params);
    if assign.save
      render json: {
        status: "SUCCESS",
        data: assign
      }
    else
      render json: {
        status: "ERROR",
        data: assign.errors.full_messages
      }
    end
  end

  def destroy
    assign = Assign.find_by(id: params[:id]);
    begin
      assign.destroy
      render json: {
        status: "SUCCESS",
        data: assign
      }
    rescue => exception
      render json: {
        status: "ERROR",
        data: "Error has occured"
      }
    end
  end

  def assign_params
    params.require(:assign).permit(:user_id, :group_id);
  end
end
