class AddHumiditySuccessToSensorReading < ActiveRecord::Migration
  def change
    add_column :sensor_readings, :humidity_success, :boolean
  end
end
