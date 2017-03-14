class AddSensorNameToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :sensor_name, :string
  end
end
