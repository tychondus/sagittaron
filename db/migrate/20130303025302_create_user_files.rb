class CreateUserFiles < ActiveRecord::Migration
  def change
    create_table :user_files do |t|
      t.string :name
      t.integer :size
      t.string :file_location
      t.string :thumb_location
      t.text :description

      t.timestamps
    end
  end
end
