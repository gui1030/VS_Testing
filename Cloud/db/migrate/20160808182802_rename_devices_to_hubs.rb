class RenameDevicesToHubs < ActiveRecord::Migration
  def change
    rename_table :devices, :hubs

    change_table :hubs do |t|
      t.rename :device_name, :name
      t.rename :device_id, :particle_id
    end
  end
end
