class Api::V1::GroupsController < ApplicationController

  def show
    group = Group.find_by(id: params[:id])

    if group
      response_created(group)
    else
      response_bad_request(group)
    end
  end

  def create
    group = current_user.groups.build(group_params)
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
    if group.update(group_params)
      response_success(group)
    else
      response_bad_request()
    end
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

end
