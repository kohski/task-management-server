# frozen_string_literal: true

FactoryBot.define do
  factory :favorite do
    user_id { User.first ? User.first.id : FactoryBot.create(:user).id }
    job_id { Job.first ? Job.first.id : FactoryBot.create(:job).id }
  end
end
