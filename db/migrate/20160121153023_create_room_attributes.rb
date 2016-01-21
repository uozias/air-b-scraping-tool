class CreateRoomAttributes < ActiveRecord::Migration
  def change
    create_table :room_attributes do |t|
      t.references :room, index: true, foreign_key: true
      t.string :title
      t.string :content

      t.timestamps null: false
    end
  end
end
