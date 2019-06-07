# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "test group #{n}" }
    owner { User.first || FactoryBot.create(:user) }
  end
end
