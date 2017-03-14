class DeviceLastOnlineToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :device_last_online, :datetime
  end
end
