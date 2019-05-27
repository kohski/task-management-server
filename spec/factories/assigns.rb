FactoryBot.define do
  factory :assign do
    group { Group.first ? Group.first : FactoryBot.create(:group) }
    user { User.first ? User.first : FactoryBot.create(:user) }
  end
end
