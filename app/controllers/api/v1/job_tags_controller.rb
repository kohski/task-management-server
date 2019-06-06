class Api::V1::JobTagsController < ApplicationController
  before_action :authenticate_api_v1_user!	

  def create
    job_tag = Job_tag.create(job_tag_params)
    if job_tag
    else
    end
  end

  def destroy
  end

  private

  def job_tag_params
    params.requrie(:job_tag).permit(:job_id, :tag_id)
  end

end
