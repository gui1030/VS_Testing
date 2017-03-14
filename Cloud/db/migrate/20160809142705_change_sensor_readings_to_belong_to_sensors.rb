class ChangeSensorReadingsToBelongToSensors < ActiveRecord::Migration
  def change
    change_table :sensor_readings do |t|
      t.change :cooler_id, :integer, null: true
      t.change :temp, :float, null: true
      t.rename :signal_dbm, :rssi
      t.rename :sensor_battery, :battery
      t.rename :parent_node, :parent_mac
      t.integer :signal_quality
      t.integer :sensor_id, index: true, foreign_key: true
    end
  end
end
