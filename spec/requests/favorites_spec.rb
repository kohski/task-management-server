require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  describe "Favorites" do
    context "Post /favorites, favorite#create" do
      login
      it "returns 201 with vadlid request" do
        job = FactoryBot.create(:job)
        post api_v1_favorites_path, headers: User.first.create_new_auth_token, params: { favorite: {job_id: job.id}}
        res_str = JSON.parse(response.body)
        favorite = Favorite.find_by(id: res_str["data"]["id"])
        expect(res_str["status"]).to be(201)
        expect(res_str["message"]).to eq("Created Favorite")
        expect(res_str["data"]["id"]).to eq(favorite.id)
        expect(res_str["data"]["job_id"]).to eq(favorite.job_id)
        expect(res_str["data"]["user_id"]).to eq(favorite.user_id)
      end

      it "returns 400 when job_id　doesn't exist" do
        job = FactoryBot.create(:job)
        post api_v1_favorites_path, headers: User.first.create_new_auth_token, params: { favorite: {job_id: (job.id + 1)}}
        res_str = JSON.parse(response.body)
        expect(res_str["status"]).to be(400)
        expect(res_str["message"]).to eq("Bad Request")
        expect(res_str["data"][0]).to include("Job must exist")
      end
    end

    context "Delete /favorites, favorite#desctory" do
      login
      it "returns 201 with vadlid request" do
        favorite = FactoryBot.create(:favorite)
        delete api_v1_favorites_path+"/"+favorite.id.to_s, headers: User.first.create_new_auth_token
        res_str = JSON.parse(response.body)
        expect(res_str["status"]).to be(200)
        expect(res_str["message"]).to eq("Success Favorite")
        expect(res_str["data"]["id"]).to eq(favorite.id)
        expect(res_str["data"]["job_id"]).to eq(favorite.job_id)
        expect(res_str["data"]["user_id"]).to eq(favorite.user_id)
      end
      it "returns 404 when favoritw doesn't exist" do
        favorite = FactoryBot.create(:favorite)
        delete api_v1_favorites_path+"/"+ (favorite.id + 1).to_s, headers: User.first.create_new_auth_token
        res_str = JSON.parse(response.body)
        expect(res_str["status"]).to be(404)
        expect(res_str["message"]).to include("Not Found")
        expect(res_str["data"]).to eq(nil)
        expect(res_str["notes"]).to eq("favorite is not found")
      end      
    end
  end
end
