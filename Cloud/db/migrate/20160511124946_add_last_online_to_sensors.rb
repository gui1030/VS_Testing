class AddLastOnlineToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :last_online, :datetime
  end
end
