# frozen_string_literal: true

class AddAdminAndDescriptionColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin, :boolean, null: false, default: false
    add_column :users, :description, :text
  end
end
