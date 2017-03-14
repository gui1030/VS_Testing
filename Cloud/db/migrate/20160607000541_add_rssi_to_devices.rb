class AddRssiToDevices < ActiveRecord::Migration
  def change
  	add_column :devices, :rssi, :integer
  end
end
