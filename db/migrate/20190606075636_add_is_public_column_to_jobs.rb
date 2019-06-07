# frozen_string_literal: true

class AddIsPublicColumnToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :is_public, :boolean, null: false, default: false
  end
end
