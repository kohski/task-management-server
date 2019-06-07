# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'JobTags', type: :request do
  describe 'Job_Tags' do
    context 'Post /job_tags, job_tags#create' do
      it 'returns 201 with valid request' do
        job = FactoryBot.create(:job)
        tag = FactoryBot.create(:tag)
        post api_v1_job_tags_path, headers: User.first.create_new_auth_token, params: { job_tag: { job_id: job.id, tag_id: tag.id } }
        res_str = JSON.parse(response.body)
        job_tag = JobTag.find_by(id: res_str['data']['id'])
        expect(res_str['status']).to be(201)
        expect(res_str['message']).to eq('Created JobTag')
        expect(res_str['data']['id']).to eq(job_tag.id)
        expect(res_str['data']['job_id']).to eq(job_tag.job_id)
        expect(res_str['data']['tag_id']).to eq(job_tag.tag_id)
      end
      it "returns 404 when job doesn't exist" do
        job = FactoryBot.create(:job)
        tag = FactoryBot.create(:tag)
        post api_v1_job_tags_path, headers: User.first.create_new_auth_token, params: { job_tag: { job_id: (job.id + 1), tag_id: tag.id } }
        res_str = JSON.parse(response.body)
        expect(res_str['status']).to be(404)
        expect(res_str['message']).to include('Not Found')
        expect(res_str['data']).to eq(nil)
        expect(res_str['notes']).to include('not found')
      end
      it "returns 404 when tag doesn't exist" do
        job = FactoryBot.create(:job)
        tag = FactoryBot.create(:tag)
        post api_v1_job_tags_path, headers: User.first.create_new_auth_token, params: { job_tag: { job_id: job.id, tag_id: (tag.id + 1) } }
        res_str = JSON.parse(response.body)
        expect(res_str['status']).to be(404)
        expect(res_str['message']).to include('Not Found')
        expect(res_str['data']).to eq(nil)
        expect(res_str['notes']).to include('not found')
      end
    end
    context 'Delete /job_tags/{job_tag_id}, job_tags#destroy' do
      login
      it 'returns 201 with valid request' do
        job_tag = FactoryBot.create(:job_tag)
        delete api_v1_job_tags_path + '/' + job_tag.id.to_s, headers: User.first.create_new_auth_token
        res_str = JSON.parse(response.body)
        expect(res_str['status']).to be(200)
        expect(res_str['message']).to eq('Success JobTag')
        expect(res_str['data']['id']).to eq(job_tag.id)
        expect(res_str['data']['job_id']).to eq(job_tag.job_id)
        expect(res_str['data']['tag_id']).to eq(job_tag.tag_id)
      end
      it "returns 404 when job_tag doesn't exist" do
        job_tag = FactoryBot.create(:job_tag)
        delete api_v1_job_tags_path + '/' + (job_tag.id + 1).to_s, headers: User.first.create_new_auth_token
        res_str = JSON.parse(response.body)
        expect(res_str['status']).to be(404)
        expect(res_str['message']).to include('Not Found')
        expect(res_str['data']).to eq(nil)
        expect(res_str['notes']).to include('not found')
      end
    end
  end
end
