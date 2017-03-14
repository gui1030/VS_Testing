class AddBatteryLevelToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :battery_level, :string, :default => "n/a"
  end
end