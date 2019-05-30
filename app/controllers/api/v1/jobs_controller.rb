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

  def show
    job = Job.find_by(id: params[:id])

    if job && job.group.users.pluck(:id).index(current_user.id)
      response_success(job)
    else
      response_not_found(job)
    end
  end

  def update
    job = Job.find_by(id: params[:id])
    unless job
      response_not_found(job)
    end
    if job.update(job_params)
      response_success(job)
    else
      response_bad_request(job)
    end
  end

  def destroy
    job = Job.find_by(id: params[:id])
    unless job
      response_not_found(job)
    end
    if job.destroy(job_params)
      response_success(job)
    else
      response_bad_request(job)
    end
  end

  def index
    jobs = Job.all
    group_ids = Assign.where(user_id: current_user.id).pluck(:group_id)
    jobs = Job.where(id: group_ids)

    if jobs.length > 0
      response_success(jobs)
    else
      response_not_found(jobs)
    end

  end

  private

  def job_params
    params.require(:job).permit(:group_id, :title, :overview, :image, :owner_id, :base_date_time, :due_date_time, :frequency,:is_done, :is_approved)
  end

end