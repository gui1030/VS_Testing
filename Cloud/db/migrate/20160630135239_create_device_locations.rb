class CreateDeviceLocations < ActiveRecord::Migration
  def change
    create_table :device_locations do |t|
      t.string :latitude
      t.string :longitude
      t.float :altitude
      t.integer :velocity
      t.datetime :gps_time
      t.references :device, :null => false
      t.timestamps null: false
    end
  end
end
