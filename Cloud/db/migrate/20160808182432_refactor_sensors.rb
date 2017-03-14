class RefactorSensors < ActiveRecord::Migration
  def change
    change_table :sensors do |t|
      t.rename :sensor_name, :name
      t.rename :sensorid, :mac
      t.string :location_type
      t.string :parent_mac
      t.index :mac, unique: true
      t.index [:location_id, :location_type], unique: true
      t.remove :battery_level
      t.integer :battery
    end
  end
end
