class Api::V1::AssignsController < ApplicationController

  def create

    if Assign.assign_existing?(assign_params)
      response_success
      return
    end

    group   = Group.find_by(id: assign_params[:group_id]);

    unless group
      response_not_found(group)
      return
    end

    assign = group.assigns.build(assign_params);
    if assign.save
      response_created(assign)
    else
      response_bad_request(assign.errors.full_messages)
    end
    
  end

  def destroy
    assign = Assign.find_by(id: params[:id]);
    begin
      assign.destroy
      response_success(assign)
    rescue => exception
      response_bad_request(assign)
    end
  end

  def assign_params
    params.require(:assign).permit(:user_id, :group_id);
  end
end
