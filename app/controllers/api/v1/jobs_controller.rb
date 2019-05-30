class Api::V1::JobsController < ApplicationController
  before_action :authenticate_user!	

  def create
    group = Group.find_by(id: job_params[:group_id])
    unless group
      response_not_found(group)
      return
    end
    job = group.jobs.build(job_params)
    if job.save
      response_created(job)
    else
      response_bad_request(job)
    end
  end


  private

  def job_params
    params.require(:job).permit(:group_id, :title, :overview, :image, :owner_id, :base_date_time, :due_date_time, :frequency,:is_done, :is_approved)
  end

end
