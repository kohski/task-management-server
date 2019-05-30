class Api::V1::StepsController < ApplicationController
  before_action :authenticate_user!	

  def create

  end

  private

  def step_params
    params.require(:step).permit()
  end

end
