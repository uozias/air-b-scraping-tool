class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :title
      t.string :url
      t.integer :capacity
      t.integer :airbnb_id, :limit => 8


      t.string :category
      t.string :capacity
      t.integer :bed_room_number
      t.integer :bed_number


      t.string :address
      t.string :area_name

      t.references :target_area

      t.timestamps null: false
    end
  end
end
