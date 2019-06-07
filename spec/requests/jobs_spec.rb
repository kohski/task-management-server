# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Jobs', type: :request do
  context 'GET /jobs, jobs#index' do
    login
    it 'return 200 with valid request' do
      job = FactoryBot.create(:job)
      get api_v1_jobs_path, headers: User.first.create_new_auth_token
      res_str = JSON.parse(response.body)

      expect(res_str['status']).to be(200)
      expect(res_str['message']).to include('Success')
      expect(res_str['data'][0]['id']).to eq(job.id)
      expect(res_str['data'][0]['group_id']).to eq(job.group_id)
      expect(res_str['data'][0]['title']).to eq(job.title)
      expect(res_str['data'][0]['overview']).to eq(job.overview)
      expect(res_str['data'][0]['image']).to eq(job.image)
      expect(res_str['data'][0]['owner_id']).to eq(job.owner_id)
      expect(Time.zone.parse(res_str['data'][0]['base_date_time']).strftime('%Y-%m-%d %H:%M:%S')).to eq(job.base_date_time.strftime('%Y-%m-%d %H:%M:%S'))
      expect(Time.zone.parse(res_str['data'][0]['due_date_time']).strftime('%Y-%m-%d %H:%M:%S')).to eq(job.due_date_time.strftime('%Y-%m-%d %H:%M:%S'))
      expect(res_str['data'][0]['frequency']).to eq(job.frequency)
      expect(res_str['data'][0]['is_done']).to eq(job.is_done)
      expect(res_str['data'][0]['is_approved']).to eq(job.is_approved)
    end

    it 'return 404 without jobs' do
      get api_v1_jobs_path, headers: User.first.create_new_auth_token
      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(404)
      expect(res_str['message']).to include('Not Found')
    end

    it 'return 404 when another user register job and current user register no job' do
      user_second = FactoryBot.create(:user)
      get api_v1_jobs_path, headers: User.first.create_new_auth_token
      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(404)
      expect(res_str['message']).to include('Not Found')
    end
  end

  context 'POST /jobs, jobs#create' do
    login
    it 'return 201 with valied request' do
      user = User.first
      group = FactoryBot.create(:group)
      post(
        api_v1_jobs_path,
        headers: User.first.create_new_auth_token,
        params: {
          job: {
            group_id: group.id,
            title: 'test job title',
            overview: 'test job overview',
            image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAAAAAAeW/F+AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAHdElNRQfjBRQABBrSkbBKAAAAT0lEQVQoz2M4gxcwjEoPkPSmjau3rNoEFULmQKSPr18/59icM2e27d2J4MClTx05Mn8+SOTUIiQOQve6DRs2rwSat+XAdgRncPh7VBoNAABwbMd4Pq/U3gAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxOS0wNS0yMFQwOTowNDoyNiswOTowMOwn1y0AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTktMDUtMjBUMDk6MDQ6MjYrMDk6MDCdem+RAAAAAElFTkSuQmCC',
            owner_id: user.id,
            base_date_time: DateTime.new,
            due_date_time: DateTime.new + 1,
            frequency: 'no_repeat',
            is_done: false,
            is_approved: false
          }
        }
      )
      res_str = JSON.parse(response.body)
      job = Job.last
      expect(res_str['status']).to be(201)
      expect(res_str['message']).to include('Created')
      expect(res_str['data']['id']).to eq(job.id)
      expect(res_str['data']['group_id']).to eq(job.group_id)
      expect(res_str['data']['title']).to eq(job.title)
      expect(res_str['data']['overview']).to eq(job.overview)
      expect(res_str['data']['image']).to eq(job.image)
      expect(res_str['data']['owner_id']).to eq(job.owner_id)
      expect(Time.zone.parse(res_str['data']['base_date_time']).strftime('%Y-%m-%d %H:%M:%S')).to eq(job.base_date_time.strftime('%Y-%m-%d %H:%M:%S'))
      expect(Time.zone.parse(res_str['data']['due_date_time']).strftime('%Y-%m-%d %H:%M:%S')).to eq(job.due_date_time.strftime('%Y-%m-%d %H:%M:%S'))
      expect(res_str['data']['frequency']).to eq(job.frequency)
      expect(res_str['data']['is_done']).to eq(job.is_done)
      expect(res_str['data']['is_approved']).to eq(job.is_approved)
    end

    it "return 404 with group which doesn't exist" do
      user = User.first
      FactoryBot.create(:group)
      group = Group.last

      post(
        api_v1_jobs_path,
        headers: User.first.create_new_auth_token,
        params: {
          job: {
            group_id: (group.id + 1),
            title: 'test job title',
            overview: 'test job overview',
            image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAAAAAAeW/F+AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAHdElNRQfjBRQABBrSkbBKAAAAT0lEQVQoz2M4gxcwjEoPkPSmjau3rNoEFULmQKSPr18/59icM2e27d2J4MClTx05Mn8+SOTUIiQOQve6DRs2rwSat+XAdgRncPh7VBoNAABwbMd4Pq/U3gAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxOS0wNS0yMFQwOTowNDoyNiswOTowMOwn1y0AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTktMDUtMjBUMDk6MDQ6MjYrMDk6MDCdem+RAAAAAElFTkSuQmCC',
            owner_id: user.id,
            base_date_time: DateTime.new,
            due_date_time: DateTime.new + 1,
            frequency: 'no_repeat',
            is_done: false,
            is_approved: false
          }
        }
      )
      res_str = JSON.parse(response.body)
      job = Job.last
      expect(res_str['status']).to be(404)
      expect(res_str['message']).to include('Not Found')
      expect(res_str['data']).to be(nil)
    end
  end

  context 'GET /jobs/{id}, jobs#show' do
    it 'return 200 with valid request' do
      job = FactoryBot.create(:job)
      get(
        api_v1_jobs_path + '/' + job.id.to_s,
        headers: User.first.create_new_auth_token
      )
      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(200)
      expect(res_str['message']).to include('Success')
      expect(res_str['data']['id']).to eq(job.id)
      expect(res_str['data']['group_id']).to eq(job.group_id)
      expect(res_str['data']['title']).to eq(job.title)
      expect(res_str['data']['overview']).to eq(job.overview)
      expect(res_str['data']['image']).to eq(job.image)
      expect(res_str['data']['owner_id']).to eq(job.owner_id)
      expect(Time.zone.parse(res_str['data']['base_date_time']).strftime('%Y-%m-%d %H:%M:%S')).to eq(job.base_date_time.strftime('%Y-%m-%d %H:%M:%S'))
      expect(Time.zone.parse(res_str['data']['due_date_time']).strftime('%Y-%m-%d %H:%M:%S')).to eq(job.due_date_time.strftime('%Y-%m-%d %H:%M:%S'))
      expect(res_str['data']['frequency']).to eq(job.frequency)
      expect(res_str['data']['is_done']).to eq(job.is_done)
      expect(res_str['data']['is_approved']).to eq(job.is_approved)
    end

    it "return 404 with job which doesn't exist" do
      job = FactoryBot.create(:job)
      get(
        api_v1_jobs_path + '/' + (job.id + 1).to_s,
        headers: User.first.create_new_auth_token
      )
      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(404)
      expect(res_str['message']).to include('Not Found')
      expect(res_str['data']).to be(nil)
    end
  end

  context 'PUT /jobs/{id}, jobs#update' do
    it 'return 200 with valid request' do
      job_before = FactoryBot.create(:job)
      put(
        api_v1_jobs_path + '/' + job_before.id.to_s,
        headers: User.first.create_new_auth_token,
        params: {
          job: {
            title: 'test job title updated',
            overview: 'test job overview updated',
            image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAAAAAAeW/F+AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAHdElNRQfjBRQABBrSkbBKAAAAT0lEQVQoz2M4gxcwjEoPkPSmjau3rNoEFULmQKSPr18/59icM2e27d2J4MClTx05Mn8+SOTUIiQOQve6DRs2rwSat+XAdgRncPh7VBoNAABwbMd4Pq/U3gAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxOS0wNS0yMFQwOTowNDoyNiswOTowMOwn1y0AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTktMDUtMjBUMDk6MDQ6MjYrMDk6MDCdem+RAAAAAElFTkSuQmCC',
            base_date_time: job_before.base_date_time + 1,
            due_date_time: job_before.due_date_time + 2,
            frequency: 'weekly',
            is_done: true,
            is_approved: true
          }
        }
      )
      res_str = JSON.parse(response.body)
      job = Job.find_by(id: job_before.id)
      expect(res_str['status']).to be(200)
      expect(res_str['message']).to include('Success')
      expect(res_str['data']['id']).to eq(job.id)
      expect(res_str['data']['group_id']).to eq(job.group_id)
      expect(res_str['data']['title']).to eq(job.title)
      expect(res_str['data']['overview']).to eq(job.overview)
      expect(res_str['data']['image']).to eq(job.image)
      expect(res_str['data']['owner_id']).to eq(job.owner_id)
      expect(Time.zone.parse(res_str['data']['base_date_time']).strftime('%Y-%m-%d %H:%M:%S')).to eq(job.base_date_time.strftime('%Y-%m-%d %H:%M:%S'))
      expect(Time.zone.parse(res_str['data']['due_date_time']).strftime('%Y-%m-%d %H:%M:%S')).to eq(job.due_date_time.strftime('%Y-%m-%d %H:%M:%S'))
      expect(res_str['data']['frequency']).to eq(job.frequency)
      expect(res_str['data']['is_done']).to eq(job.is_done)
      expect(res_str['data']['is_approved']).to eq(job.is_approved)
    end

    it "return 404 with group which doesn't exist" do
      job = FactoryBot.create(:job)
      group = Group.last
      put(
        api_v1_jobs_path + '/' + job.id.to_s,
        headers: User.first.create_new_auth_token,
        params: {
          job: {
            group_id: (group.id + 1).to_s
          }
        }
      )
      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(404)
      expect(res_str['message']).to include('Not Found')
    end
  end

  context 'DELETE /jobs/{id}, jobs#destroy' do
    it 'return 200 with valid request' do
      job = FactoryBot.create(:job)
      delete(
        api_v1_jobs_path + '/' + job.id.to_s,
        headers: User.first.create_new_auth_token
      )
      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(200)
      expect(res_str['message']).to include('Success')
    end

    it "return 404 with group which doesn't exist" do
      job = FactoryBot.create(:job)
      delete(
        api_v1_jobs_path + '/' + (job.id + 1).to_s,
        headers: User.first.create_new_auth_token
      )

      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(404)
      expect(res_str['message']).to include('Not Found')
    end
  end

  context 'GET /public_jobs, jobs#public_jobs' do
    login
    it 'return 200 with valid request' do
      public_job = FactoryBot.create(:job, is_public: true)
      public_job_second = FactoryBot.create(:job, is_public: true)
      private_job = FactoryBot.create(:job)
      get public_jobs_api_v1_jobs_path, headers: User.first.create_new_auth_token
      res_str = JSON.parse(response.body)

      expect(res_str['status']).to be(200)
      expect(res_str['message']).to include('Success')
      expect(res_str['data'].length).to eq(Job.where(is_public: true).length)
      expect(res_str['data'][0]['id']).to eq(public_job.id)
      expect(res_str['data'][0]['group_id']).to eq(public_job.group_id)
      expect(res_str['data'][0]['title']).to eq(public_job.title)
      expect(res_str['data'][0]['overview']).to eq(public_job.overview)
      expect(res_str['data'][0]['image']).to eq(public_job.image)
      expect(res_str['data'][0]['owner_id']).to eq(public_job.owner_id)
      expect(Time.zone.parse(res_str['data'][0]['base_date_time']).strftime('%Y-%m-%d %H:%M:%S')).to eq(public_job.base_date_time.strftime('%Y-%m-%d %H:%M:%S'))
      expect(Time.zone.parse(res_str['data'][0]['due_date_time']).strftime('%Y-%m-%d %H:%M:%S')).to eq(public_job.due_date_time.strftime('%Y-%m-%d %H:%M:%S'))
      expect(res_str['data'][0]['frequency']).to eq(public_job.frequency)
      expect(res_str['data'][0]['is_done']).to eq(public_job.is_done)
      expect(res_str['data'][0]['is_approved']).to eq(public_job.is_approved)
    end

    it 'return 404 without jobs' do
      get public_jobs_api_v1_jobs_path, headers: User.first.create_new_auth_token
      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(404)
      expect(res_str['message']).to include('Not Found')
    end

    it 'return 404 when all jobs are not public' do
      private_job = FactoryBot.create(:job)
      private_job_second = FactoryBot.create(:job)
      get public_jobs_api_v1_jobs_path, headers: User.first.create_new_auth_token
      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(404)
      expect(res_str['message']).to include('Not Found')
    end
  end
end
