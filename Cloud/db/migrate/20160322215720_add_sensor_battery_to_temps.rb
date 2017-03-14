class AddSensorBatteryToTemps < ActiveRecord::Migration
  def change
    add_column :temps, :sensor_battery, :integer
  end
end
