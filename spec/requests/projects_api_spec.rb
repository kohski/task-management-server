require 'rails_helper'
RSpec.describe "ProjectsApis", type: :request do
  describe "Groups" do
    login
    it "GET /group" do
      group = FactoryBot.create(:group)
      get api_v1_groups_path + "/" + group.id.to_s, headers: group.owner.create_new_auth_token
      res_str = JSON.parse(response.body)
      expect(res_str["status"]).to be(201)
      expect(res_str["data"]["id"]).to eq(group.id)
      expect(res_str["data"]["owner_id"]).to eq(group.owner_id)
      expect(res_str["data"]["name"]).to eq(group.name)
    end
  end











end









