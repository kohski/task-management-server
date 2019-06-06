class Api::V1::TagsController < ApplicationController
  before_action :authenticate_api_v1_user!	

  def create

    exists_tag = tag_exists_check(tag_params[:name])
    if exists_tag
      response_success(exists_tag)
      return
    end
  
    tag = Tag.create(tag_params)
    if tag.valid?
      response_created(tag)
    else
      response_bad_request(tag)
    end
  end

  def destroy
    if tag = Tag.find_by(id: params[:id])
      tag.destroy
      response_success(tag)
    else
      response_not_found_with_notes(tag, "tag is not found")
    end


  end

  def index
    tags = Tag.all
    if !tags.empty?
      response_success(tags)
    else
      response_not_found(tags)
    end

  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

  def tag_exists_check(name)
    Tag.find_by(name: name)
  end

end
