# frozen_string_literal: true

class Api::V1::JobTagsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def create
    job = Job.find_by(id: job_tag_params[:job_id])
    if job.nil?
      response_not_found_with_notes(job, 'job is not found')
      return
    end

    tag = Tag.find_by(id: job_tag_params[:tag_id])
    if tag.nil?
      response_not_found_with_notes(tag, 'tag is not found')
      return
    end

    job_tag = JobTag.create(job_tag_params)
    if job_tag
      response_created(job_tag)
    else
      response_bad_request(job_tag)
    end
  end

  def destroy
    if job_tag = JobTag.find_by(id: params[:id])
      job_tag.destroy
      response_success(job_tag)
    else
      response_not_found_with_notes(job_tag, 'tag is not found')
    end
  end

  private

  def job_tag_params
    params.require(:job_tag).permit(:job_id, :tag_id)
  end
end
