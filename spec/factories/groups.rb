FactoryBot.define do
  factory :group do
    name { "test group" }
    owner { User.first }
  end
end
