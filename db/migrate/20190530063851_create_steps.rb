class CreateSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :steps do |t|
      t.integer :job_id, null: false
      t.string :name, null: false
      t.integer :assgined_user
      t.string :image
      t.datetime :due_date
      t.boolean :is_done
      t.boolean :is_approved
      t.integer :order
      t.timestamps
    end
    add_foreign_key :steps, :jobs, column: :job_id
  end
end
