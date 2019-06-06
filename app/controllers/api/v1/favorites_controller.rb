class Api::V1::FavoritesController < ApplicationController
  before_action :authenticate_api_v1_user!

  def create
    favorite = current_api_v1_user.favorites.create(favorite_params)
    if favorite.valid?
      response_created(favorite)
    else
      response_bad_request(favorite)
    end
  end

  def destroy
    if favorite = Favorite.find_by(id: params[:id])
      favorite.destroy
      response_success(favorite)
    else
      response_not_found_with_notes(favorite, "favorite is not found")
    end
  end

  def favorite_params
    params.require(:favorite).permit(:job_id, :user_id)
  end

end
