# frozen_string_literal: true

FactoryBot.define do
  factory :assign do
    group { Group.first || FactoryBot.create(:group) }
    user { User.first || FactoryBot.create(:user) }
  end
end
