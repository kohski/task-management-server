FactoryBot.define do
  factory :group do
    name { "test group" }
    owner { User.first ? User.first : FactoryBot.create(:user) }
  end
end
