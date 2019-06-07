# frozen_string_literal: true

class Api::V1::StepsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def create
    step = Step.new(step_params)
    if step.save
      response_created(step)
    else
      response_not_found_with_notes(step.attributes, 'step is not found')
    end
  end

  def update
    step = Step.find_by(id: params[:id])
    unless step
      response_not_found(step)
      return
    end

    if step.update(step_params)
      response_success(step)
    else
      response_bad_request(step)
    end
  end

  def show
    step = Step.find_by(id: params[:id])

    if step
      response_success(step)
    else
      response_not_found(step)
    end
  end

  def index
    # TODO: resolve N+1 problem
    steps = Group.where(id: current_api_v1_user.assigns.pluck(:group_id)).map(&:steps).flatten
    if steps.empty?
      response_not_found(steps)
    else
      response_success(steps)
    end
  end

  def destroy
    step = Step.find_by(id: params[:id])
    unless step
      response_not_found(step)
      return
    end

    if step.destroy
      response_success(step)
    else
      response_bad_request(step)
    end
  end

  private

  def step_params
    params.require(:step).permit(:job_id, :content, :assigned_user, :image, :due_date, :is_done, :is_approved, :order)
  end
end
