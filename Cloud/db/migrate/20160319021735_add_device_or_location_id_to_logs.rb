class AddDeviceOrLocationIdToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :device_or_location_id, :integer
  end
end
