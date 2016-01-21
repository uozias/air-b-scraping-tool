class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :title
      t.string :url
      t.integer :capacity

      t.timestamps null: false
    end
  end
end
