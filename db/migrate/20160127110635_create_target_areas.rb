class CreateTargetAreas < ActiveRecord::Migration
  def change
    create_table :target_areas do |t|
      t.string :name
      t.string :category
      t.string :rail_line
      t.references :target_area, index: true

      t.timestamps null: false
    end
  end
end
