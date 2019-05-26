class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.integer :owner_id
      t.string :name, null: false
      t.timestamps
    end
    add_foreign_key :groups, :users, column: :owner_id
  end
end
