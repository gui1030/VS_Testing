class AddRssiToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :rssi, :integer
  end
end
