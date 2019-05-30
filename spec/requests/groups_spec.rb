require 'rails_helper'
RSpec.describe "ProjectsApis", type: :request do
  describe "Groups" do
    context "GET /groups/{id}, groups#show" do
      login
      it "return 201 response when request is valid" do
        group = FactoryBot.create(:group)
        get api_v1_groups_path + "/" + group.id.to_s, headers: group.owner.create_new_auth_token
        res_str = JSON.parse(response.body)
        expect(res_str["status"]).to be(201)
        expect(res_str["data"]["id"]).to eq(group.id)
        expect(res_str["data"]["owner_id"]).to eq(group.owner_id)
        expect(res_str["data"]["name"]).to eq(group.name)
      end
  
      it "return 401 when no-exists group is specified" do
        group = FactoryBot.create(:group)
        get api_v1_groups_path + "/" + (Group.last.id + 1).to_s, headers: group.owner.create_new_auth_token

        res_str = JSON.parse(response.body)
        expect(res_str["status"]).to be(400)
        expect(res_str["message"]).to eq("Bad Request")
      end  
    end

    context "POST /groups, groups#create" do
      login
      it "return 201 response with valid request" do
        post api_v1_groups_path, headers: User.first.create_new_auth_token, params: { group: {name: "test group"} }
        res_str = JSON.parse(response.body)
        group = Group.last
        expect(res_str["status"]).to be(201)
        expect(res_str["data"]["id"]).to eq(group.id)
        expect(res_str["data"]["owner_id"]).to eq(group.owner_id)
        expect(res_str["data"]["name"]).to eq(group.name)
      end
  
      it "return 400 response when duplicate name is specified" do
        FactoryBot.create(:group, name: "test duplicate group name")
        post api_v1_groups_path, headers: User.first.create_new_auth_token, params: { group: {name: "test duplicate group name"} }
        res_str = JSON.parse(response.body)
        group = Group.last
        expect(res_str["status"]).to be(400)
        expect(res_str["message"]).to eq("Bad Request")
        expect(res_str["data"][0]).to eq("Name has already been taken")
      end

      it "return 400 response when duplicate name is blank" do
        post api_v1_groups_path, headers: User.first.create_new_auth_token, params: { group: {name: ""} }
        res_str = JSON.parse(response.body)
        group = Group.last
        expect(res_str["status"]).to be(400)
        expect(res_str["message"]).to eq("Bad Request")
        expect(res_str["data"][0]).to eq("Name can't be blank")
      end
    end

    context "DELETE /groups/{id}, groups#destroy" do
      login
      it "return 200 response with valid request" do
        group = FactoryBot.create(:group)
        delete api_v1_groups_path+"/#{group.id}", headers: group.owner.create_new_auth_token
        res_str = JSON.parse(response.body)
        group = Group.last
        expect(res_str["status"]).to be(200)
        expect(res_str["message"]).to eq("Success Group")
      end
  
      it "return 400 response when no-exists group is specified" do
        group = FactoryBot.create(:group)
        delete api_v1_groups_path+"/#{Group.last.id + 1}", headers: group.owner.create_new_auth_token
        res_str = JSON.parse(response.body)
        group = Group.last
        expect(res_str["status"]).to be(400)
        expect(res_str["message"]).to eq("Bad Request")
      end
    end

    context "PUT /groups/{id}, groups#destroy" do
      login
      it "return 200" do
        group = FactoryBot.create(:group)
        put api_v1_groups_path+"/#{group.id}", headers: group.owner.create_new_auth_token, params: { group: { name: "test group update" } }
        res_str = JSON.parse(response.body)
        group = Group.last
        expect(res_str["status"]).to be(200)
        expect(res_str["message"]).to eq("Success Group")
        expect(res_str["data"]["id"]).to eq(group.id)
        expect(res_str["data"]["name"]).to eq(group.name)
        expect(res_str["data"]["owner_id"]).to eq(group.owner_id)
      end
    end
  end
end
