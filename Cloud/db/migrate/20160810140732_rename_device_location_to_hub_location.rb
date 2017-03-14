class RenameDeviceLocationToHubLocation < ActiveRecord::Migration
  def change
    rename_table :device_locations, :hub_locations
    rename_column :hub_locations, :device_id, :hub_id
  end
end
