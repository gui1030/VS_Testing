class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :location_name
      t.integer :top_temp_threshold
      t.integer :bottom_temp_threshold
      t.references :tenant
      t.timestamps null: false
    end
  end
end
