# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  describe 'Tag' do
    context 'POST /tags, tags#create' do
      login
      it 'return 200 with exist' do
        tag = FactoryBot.create(:tag)
        post api_v1_tags_path, headers: User.first.create_new_auth_token, params: { tag: { name: tag.name } }
        res_str = JSON.parse(response.body)
        expect(res_str['status']).to be(200)
        expect(res_str['data']['id']).to eq(tag.id)
        expect(res_str['data']['name']).to eq(tag.name)
      end
      it 'return 201 with new tag request' do
        post api_v1_tags_path, headers: User.first.create_new_auth_token, params: { tag: { name: 'test tag' } }
        res_str = JSON.parse(response.body)
        tag = Tag.last
        expect(res_str['status']).to be(201)
        expect(res_str['data']['id']).to eq(tag.id)
        expect(res_str['data']['name']).to eq(tag.name)
      end
      it 'return 400 without name in request body' do
        post api_v1_tags_path, headers: User.first.create_new_auth_token, params: { tag: { bad_params: 'test tag' } }
        res_str = JSON.parse(response.body)
        tag = Tag.last
        expect(res_str['status']).to be(400)
        expect(res_str['data']).to include("Name can't be blank")
      end
    end
    context 'GET /tags, tags#index' do
      login
      it 'return 201 with valid tag request' do
        tag = FactoryBot.create(:tag)
        tag2 = FactoryBot.create(:tag)
        get api_v1_tags_path, headers: User.first.create_new_auth_token
        res_str = JSON.parse(response.body)
        expect(res_str['status']).to be(200)
        expect(res_str['data'].length).to eq(Tag.all.length)
        expect(res_str['data'][0]['id']).to eq(tag.id)
        expect(res_str['data'][0]['name']).to eq(tag.name)
      end
      it 'return 404 without tags' do
        get api_v1_tags_path, headers: User.first.create_new_auth_token
        res_str = JSON.parse(response.body)
        expect(res_str['status']).to be(404)
        expect(res_str['data']).to eq([])
      end
    end
    context 'DELETE /tags, tags#destroy' do
      login
      it 'return 200 with new tag request' do
        tag = FactoryBot.create(:tag)
        delete api_v1_tags_path + '/' + tag.id.to_s, headers: User.first.create_new_auth_token
        res_str = JSON.parse(response.body)
        expect(res_str['status']).to be(200)
        expect(res_str['data']['id']).to eq(tag.id)
        expect(res_str['data']['name']).to eq(tag.name)
      end
      it 'return 404 without tags' do
        tag = FactoryBot.create(:tag)
        delete api_v1_tags_path + '/' + (tag.id + 1).to_s, headers: User.first.create_new_auth_token
        res_str = JSON.parse(response.body)
        expect(res_str['status']).to be(404)
        expect(res_str['data']).to eq(nil)
        expect(res_str['notes']).to eq('tag is not found')
      end
    end
  end
end
