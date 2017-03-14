class AddBatteryLevelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :battery_level, :float
  end
end
