class Api::V1::GroupsController < ApplicationController
  before_action :authenticate_api_v1_user!	

  def show
    group = Group.find_by(id: params[:id])

    if group
      response_created(group)
    else
      response_bad_request(group)
    end
  end

  def create
    group = current_api_v1_user.groups.build(group_params)
    if group.save
      response_created(group)
    else
      response_bad_request(group)
    end
  end

  def destroy
    if group = Group.find_by(id: params[:id])
      group.destroy
      response_success(group)
    else
      response_bad_request(group)
    end
  end

  def update
    group = Group.find_by(id: params[:id])

    unless group
      response_not_found_with_notes(group, "group is not found")
      return
    end

    if group.update(group_params)
      response_success(group)
    else
      response_bad_request(group)
    end
  end

  def index
    groups = current_api_v1_user.groups
    if groups.empty?
      response_not_found(groups)
    else
      response_success(groups)
    end
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end
end
