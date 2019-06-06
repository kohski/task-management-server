FactoryBot.define do
  factory :tag do
    sequence(:name){|n| "test tag #{n}"}
  end
end
