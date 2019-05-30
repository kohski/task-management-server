FactoryBot.define do
  factory :step do
    job_id { 1 }
    name { "MyString" }
    assgined { 1 }
    image { "MyString" }
    due_date { "2019-05-30 15:38:51" }
    is_done { false }
    is_approved { false }
    previous_step_id { 1 }
  end
end
