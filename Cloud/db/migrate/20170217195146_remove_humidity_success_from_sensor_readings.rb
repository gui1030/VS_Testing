class RemoveHumiditySuccessFromSensorReadings < ActiveRecord::Migration
  def change
    remove_column :sensor_readings, :humidity_success, :boolean
  end
end
