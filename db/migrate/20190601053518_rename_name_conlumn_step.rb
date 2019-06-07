# frozen_string_literal: true

class RenameNameConlumnStep < ActiveRecord::Migration[5.2]
  def change
    rename_column :steps, :name, :content
  end
end
