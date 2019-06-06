FactoryBot.define do
  factory :job_tag do
    job_id { Job.first ? Job.first.id : FactoryBot.create(:job).id }
    tag_id { Tag.first ? Tag.first.id : FactoryBot.create(:tag).id }
  end
end
