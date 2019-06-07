# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Assigns', type: :request do
  describe 'assigns' do
    context 'POST /assigns, assigns#create' do
      login
      it 'return 201 with valid request' do
        user = FactoryBot.create(:user)
        group = FactoryBot.create(:group)
        post api_v1_assigns_path, headers: User.first.create_new_auth_token, params: { assign: { user_id: user.id, group_id: group.id } }
        res_str = JSON.parse(response.body)
        assign = Assign.find_by(id: res_str['data']['id'])
        expect(res_str['status']).to be(201)
        expect(res_str['message']).to eq('Created Assign')
        expect(res_str['data']['id']).to eq(assign.id)
        expect(res_str['data']['group_id']).to eq(assign.group_id)
        expect(res_str['data']['user_id']).to eq(assign.user_id)
      end

      it 'return 200 with duplicate assign' do
        group = FactoryBot.create(:group)
        assign = Assign.first
        post api_v1_assigns_path, headers: User.first.create_new_auth_token, params: { assign: { user_id: assign.user_id, group_id: assign.group_id } }

        res_str = JSON.parse(response.body)

        expect(res_str['status']).to be(200)
        expect(res_str['message']).to include('Success')
        expect(res_str['data']['id']).to eq(assign.id)
        expect(res_str['data']['group_id']).to eq(assign.group_id)
        expect(res_str['data']['user_id']).to eq(assign.user_id)
      end

      it "return 404 if group doesn't exist" do
        assign = FactoryBot.create(:assign)
        post api_v1_assigns_path, headers: User.first.create_new_auth_token, params: { assign: { user_id: assign.user_id, group_id: (assign.group_id + 1) } }
        res_str = JSON.parse(response.body)
        expect(res_str['status']).to be(404)
        expect(res_str['message']).to include('Not Found')
        expect(res_str['data']).to be(nil)
      end

      it "return 404 if user doesn't exsit" do
        assign = FactoryBot.create(:assign)
        post api_v1_assigns_path, headers: User.first.create_new_auth_token, params: { assign: { user_id: (assign.user_id + 1), group_id: assign.group_id } }
        res_str = JSON.parse(response.body)
        expect(res_str['status']).to be(404)
        expect(res_str['message']).to include('Not Found')
        expect(res_str['data']).to be(nil)
      end
    end

    context 'DELETE /assigns, assigns#create' do
      login
      it 'return 200 with valid delete request' do
        assign = FactoryBot.create(:assign)
        delete api_v1_assigns_path + '/' + assign.id.to_s, headers: User.first.create_new_auth_token
        res_str = JSON.parse(response.body)
        expect(res_str['status']).to be(200)
        expect(res_str['message']).to include('Success')
        expect(res_str['data']['id']).to eq(assign.id)
        expect(res_str['data']['group_id']).to eq(assign.group_id)
        expect(res_str['data']['user_id']).to eq(assign.user_id)
      end

      it 'return 400 if request no-exsits assign delete' do
        assign = FactoryBot.create(:assign)
        delete api_v1_assigns_path + '/' + (assign.id + 1).to_s, headers: User.first.create_new_auth_token
        res_str = JSON.parse(response.body)
        expect(res_str['status']).to be(400)
        expect(res_str['message']).to eq('Bad Request')
        expect(res_str['data']).to be(nil)
      end
    end
  end
end
