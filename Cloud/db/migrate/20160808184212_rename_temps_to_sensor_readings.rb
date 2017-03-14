class RenameTempsToSensorReadings < ActiveRecord::Migration
  def change
    rename_table :temps, :sensor_readings
  end
end
