# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assign, type: :model do
  context 'foreign key must exist' do
    it "can't be created without group" do
      assign = FactoryBot.build(:assign, group: nil)
      assign.valid?
      expect(assign.errors.full_messages).to include('Group must exist')
    end

    it "can't be created without user" do
      assign = FactoryBot.build(:assign, user: nil)
      assign.valid?
      expect(assign.errors.full_messages).to include('User must exist')
    end

    it 'can be created with both group and user' do
      assign = FactoryBot.build(:assign)
      assign.valid?
      expect(assign.errors.full_messages.length).to eq 0
    end
  end

  context 'class method' do
    context 'when duplicate assign request recieve' do
      it 'return true from assign_existing method' do
        user = FactoryBot.create(:user)
        group = FactoryBot.create(:group)
        assign = Assign.first
        answer = Assign.assign_existing?(group_id: assign.group_id, user_id: assign.user_id)
        expect(answer[0][:user_id]).to be(assign.user_id)
        expect(answer[0][:group_id]).to be(assign.group_id)
      end
    end
  end
  # pending "add some examples to (or delete) #{__FILE__}"
end
