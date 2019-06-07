# frozen_string_literal: true

class AddReferenceToGroupId < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :assigns, :users, column: :user_id
    add_foreign_key :assigns, :groups, column: :group_id
  end
end
