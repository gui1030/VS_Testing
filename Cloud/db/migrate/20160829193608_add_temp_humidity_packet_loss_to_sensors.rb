class AddTempHumidityPacketLossToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :temp, :float
    add_column :sensors, :humidity, :float
    add_column :sensors, :packet_loss, :integer
  end
end
