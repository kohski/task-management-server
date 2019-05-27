class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.integer :group_id
      t.string :title, null: false
      t.text :overview
      t.string :image
      t.integer :owner_id
      t.datetime :base_date_time
      t.datetime :due_date_time
      t.integer :frequency, default: 0
      t.boolean :is_done
      t.boolean :is_approved
      t.timestamps
    end
    add_foreign_key :jobs, :users, column: :owner_id
    add_foreign_key :jobs, :groups, column: :group_id
  end
end
