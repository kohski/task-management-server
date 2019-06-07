# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Steps', type: :request do
  context 'GET /steps, steps#index' do
    login
    it 'return 200 with valid request' do
      step = FactoryBot.create(:step)
      step2 = FactoryBot.create(:step)
      get(
        api_v1_steps_path,
        headers: User.first.create_new_auth_token
      )
      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(200)
      expect(res_str['message']).to include('Success')
      expect(res_str['data'].length).to eq(2)
      expect(res_str['data'][0]['id']).to eq(step.id)
      expect(res_str['data'][0]['job_id']).to eq(step.job_id)
      expect(res_str['data'][0]['content']).to eq(step.content)
      expect(res_str['data'][0]['assigned_user']).to eq(step.assigned_user)
      expect(res_str['data'][0]['image']).to eq(step.image)
      expect(Time.zone.parse(res_str['data'][0]['due_date']).strftime('%Y-%m-%d %H:%M:%S')).to eq(step.due_date.strftime('%Y-%m-%d %H:%M:%S'))
      expect(res_str['data'][0]['is_done']).to eq(step.is_done)
      expect(res_str['data'][0]['is_approved']).to eq(step.is_approved)
      expect(res_str['data'][0]['order']).to eq(step.order)
    end

    it 'return 404 without steps' do
      get(
        api_v1_steps_path,
        headers: User.first.create_new_auth_token
      )
      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(404)
      expect(res_str['message']).to include('Not Found')
    end

    it 'return 404 when another user register job and current user register no job' do
      step = FactoryBot.create(:step)
      anothr_user = FactoryBot.create(:user)
      group = FactoryBot.create(:group, name: 'test another group', owner: anothr_user)
      job = FactoryBot.create(:job, group: group, owner: group.owner)
      another_step = FactoryBot.create(:step, job: job)
      get(
        api_v1_steps_path,
        headers: User.first.create_new_auth_token
      )
      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(200)
      expect(res_str['message']).to include('Success')
      expect(res_str['data'][0]['id']).to_not eq(another_step.id)
      expect(res_str['data'][0]['id']).to eq(step.id)
    end
  end

  context 'POST /steps, steps#create' do
    login
    it 'return 201 with valied request' do
      job = FactoryBot.create(:job)
      post(
        api_v1_steps_path,
        headers: User.first.create_new_auth_token,
        params: {
          step: {
            job_id: job.id,
            content: 'test step first',
            assigned_user: job.owner.id,
            image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAAAAAAeW/F+AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAHdElNRQfjBRQABBrSkbBKAAAAT0lEQVQoz2M4gxcwjEoPkPSmjau3rNoEFULmQKSPr18/59icM2e27d2J4MClTx05Mn8+SOTUIiQOQve6DRs2rwSat+XAdgRncPh7VBoNAABwbMd4Pq/U3gAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxOS0wNS0yMFQwOTowNDoyNiswOTowMOwn1y0AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTktMDUtMjBUMDk6MDQ6MjYrMDk6MDCdem+RAAAAAElFTkSuQmCC',
            due_date: DateTime.new + 1,
            is_done: false,
            is_approved: false,
            order: 1
          }
        }
      )
      res_str = JSON.parse(response.body)
      step = Step.last
      expect(res_str['status']).to be(201)
      expect(res_str['message']).to include('Created')

      expect(res_str['data']['id']).to eq(step.id)
      expect(res_str['data']['job_id']).to eq(step.job_id)
      expect(res_str['data']['assigned_user']).to eq(step.assigned_user)
      expect(res_str['data']['image']).to eq(step.image)
      expect(Time.zone.parse(res_str['data']['due_date']).strftime('%Y-%m-%d %H:%M:%S')).to eq(step.due_date.strftime('%Y-%m-%d %H:%M:%S'))
      expect(res_str['data']['is_done']).to eq(step.is_done)
      expect(res_str['data']['is_approved']).to eq(step.is_approved)
      expect(res_str['data']['order']).to eq(step.order)
    end

    it "return 404 with job which doesn't exist" do
      job = FactoryBot.create(:job)
      post(
        api_v1_steps_path,
        headers: User.first.create_new_auth_token,
        params: {
          step: {
            job_id: (job.id + 1),
            content: 'test step first',
            assigned_user: job.owner.id,
            image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAAAAAAeW/F+AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAHdElNRQfjBRQABBrSkbBKAAAAT0lEQVQoz2M4gxcwjEoPkPSmjau3rNoEFULmQKSPr18/59icM2e27d2J4MClTx05Mn8+SOTUIiQOQve6DRs2rwSat+XAdgRncPh7VBoNAABwbMd4Pq/U3gAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxOS0wNS0yMFQwOTowNDoyNiswOTowMOwn1y0AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTktMDUtMjBUMDk6MDQ6MjYrMDk6MDCdem+RAAAAAElFTkSuQmCC',
            due_date: DateTime.new + 1,
            is_done: false,
            is_approved: false,
            order: 1
          }
        }
      )
      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(404)
      expect(res_str['message']).to include('Not Found')
    end
  end

  context 'GET /steps/{id}, steps#show' do
    it 'return 200 with valid request' do
      step = FactoryBot.create(:step)
      get(
        api_v1_steps_path + '/' + step.id.to_s,
        headers: User.first.create_new_auth_token
      )
      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(200)
      expect(res_str['message']).to include('Success')
      expect(res_str['data']['id']).to eq(step.id)
      expect(res_str['data']['job_id']).to eq(step.job_id)
      expect(res_str['data']['content']).to eq(step.content)
      expect(res_str['data']['assigned_user']).to eq(step.assigned_user)
      expect(res_str['data']['image']).to eq(step.image)
      expect(Time.zone.parse(res_str['data']['due_date']).strftime('%Y-%m-%d %H:%M:%S')).to eq(step.due_date.strftime('%Y-%m-%d %H:%M:%S'))
      expect(res_str['data']['is_done']).to eq(step.is_done)
      expect(res_str['data']['is_approved']).to eq(step.is_approved)
      expect(res_str['data']['order']).to eq(step.order)
    end

    it "return 404 with job which doesn't exist" do
      step = FactoryBot.create(:step)
      get(
        api_v1_steps_path + '/' + (step.id + 1).to_s,
        headers: User.first.create_new_auth_token
      )
      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(404)
      expect(res_str['message']).to include('Not Found')
    end
  end

  context 'PUT /steps/{id}, steps#update' do
    it 'return 200 with valid request' do
      step = FactoryBot.create(:step)
      put(
        api_v1_steps_path + '/' + step.id.to_s,
        headers: User.first.create_new_auth_token,
        params: {
          step: {
            content: 'test step first updated',
            image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAAAAAAeW/F+AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAHdElNRQfjBRQABBrSkbBKAAAAT0lEQVQoz2M4gxcwjEoPkPSmjau3rNoEFULmQKSPr18/59icM2e27d2J4MClTx05Mn8+SOTUIiQOQve6DRs2rwSat+XAdgRncPh7VBoNAABwbMd4Pq/U3gAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxOS0wNS0yMFQwOTowNDoyNiswOTowMOwn1y0AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTktMDUtMjBUMDk6MDQ6MjYrMDk6MDCdem+RAAAAAElFTkSuQmCC',
            due_date: DateTime.new + 2,
            is_done: false,
            is_approved: false,
            order: 1
          }
        }
      )
      res_str = JSON.parse(response.body)
      updated_step = Step.last
      expect(res_str['status']).to be(200)
      expect(res_str['message']).to include('Success')
      expect(res_str['data']['id']).to eq(updated_step.id)
      expect(res_str['data']['job_id']).to eq(updated_step.job_id)
      expect(res_str['data']['assigned_user']).to eq(updated_step.assigned_user)
      expect(res_str['data']['image']).to eq(updated_step.image)
      expect(Time.zone.parse(res_str['data']['due_date']).strftime('%Y-%m-%d %H:%M:%S')).to eq(updated_step.due_date.strftime('%Y-%m-%d %H:%M:%S'))
      expect(res_str['data']['is_done']).to eq(updated_step.is_done)
      expect(res_str['data']['is_approved']).to eq(updated_step.is_approved)
      expect(res_str['data']['order']).to eq(updated_step.order)
    end

    it "return 404 with group which doesn't exist" do
      step = FactoryBot.create(:step)
      put(
        api_v1_steps_path + '/' + (step.id + 1).to_s,
        headers: User.first.create_new_auth_token,
        params: {
          step: {
            content: 'test step first updated',
            image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAAAAAAeW/F+AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAHdElNRQfjBRQABBrSkbBKAAAAT0lEQVQoz2M4gxcwjEoPkPSmjau3rNoEFULmQKSPr18/59icM2e27d2J4MClTx05Mn8+SOTUIiQOQve6DRs2rwSat+XAdgRncPh7VBoNAABwbMd4Pq/U3gAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxOS0wNS0yMFQwOTowNDoyNiswOTowMOwn1y0AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTktMDUtMjBUMDk6MDQ6MjYrMDk6MDCdem+RAAAAAElFTkSuQmCC',
            due_date: DateTime.new + 2,
            is_done: false,
            is_approved: false,
            order: 1
          }
        }
      )
      res_str = JSON.parse(response.body)
      updated_step = Step.last
      expect(res_str['status']).to be(404)
      expect(res_str['message']).to include('Not Found')
    end
  end

  context 'DELETE /steps/{id}, steps#destroy' do
    it 'return 200 with valid request' do
      step = FactoryBot.create(:step)
      delete(
        api_v1_steps_path + '/' + step.id.to_s,
        headers: User.first.create_new_auth_token
      )
      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(200)
      expect(res_str['message']).to include('Success')
      expect(Step.find_by(id: step.id)).to be(nil)
    end

    it "return 404 with group which doesn't exist" do
      step = FactoryBot.create(:step)
      delete(
        api_v1_steps_path + '/' + (step.id + 1).to_s,
        headers: User.first.create_new_auth_token
      )
      res_str = JSON.parse(response.body)
      expect(res_str['status']).to be(404)
      expect(res_str['message']).to include('Not Found')
    end
  end
end
