class RemoveIndexFromDevices < ActiveRecord::Migration
  def change
    remove_index :devices, :name => "index_devices_on_device_id"
    remove_index :devices, :name => "index_devices_on_sim_id"
  end
end
