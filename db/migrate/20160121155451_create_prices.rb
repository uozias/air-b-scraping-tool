class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.references :room, index: true, foreign_key: true
      t.datetime :target_date

      t.timestamps null: false
    end
  end
end
