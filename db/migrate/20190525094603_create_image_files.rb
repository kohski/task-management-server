class CreateImageFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :image_files do |t|
      t.string :title
      t.string :image
      t.string :name      
      t.timestamps
    end
  end
end
