# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'validation test' do
    context 'name column' do
      it 'is invalid without name' do
        group = FactoryBot.build(:group, name: nil)
        group.valid?
        expect(group.errors[:name]).to include("can't be blank")
      end
      it 'is valid with name' do
        group = FactoryBot.build(:group)
        group.valid?
        expect(group.errors[:name]).to_not include("can't be blank")
      end
      it 'is invalid with duplicated name' do
        group_before = FactoryBot.create(:group)
        group = FactoryBot.build(:group, name: group_before.name)
        group.valid?
        expect(group.errors[:name]).to include('has already been taken')
      end
    end
  end

  describe 'foreign key test' do
    it "can't be created without owner" do
      group = FactoryBot.build(:group, owner: nil)
      group.valid?
      expect(group.errors[:owner]).to include('must exist')
    end
    it 'can be created with owner' do
      group = FactoryBot.build(:group)
      group.valid?
      expect(group.errors[:owner]).to_not include('must exist')
    end
  end

  # pending "add some examples to (or delete) #{__FILE__}"
end
