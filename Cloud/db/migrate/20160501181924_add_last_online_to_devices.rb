class AddLastOnlineToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :last_online, :datetime
  end
end
