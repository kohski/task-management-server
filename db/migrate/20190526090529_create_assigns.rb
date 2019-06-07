# frozen_string_literal: true

class CreateAssigns < ActiveRecord::Migration[5.2]
  def change
    create_table :assigns do |t|
      t.integer :group_id, null: false
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
