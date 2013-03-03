class CreateUserFiles < ActiveRecord::Migration
  def change
    create_table :user_files do |t|
      t.string :name
      t.integer :size
      t.string :uuid
      t.text :description

      t.timestamps
    end
  end
end
