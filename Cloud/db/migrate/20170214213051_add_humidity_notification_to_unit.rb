class AddHumidityNotificationToUnit < ActiveRecord::Migration
  def change
    add_column :units, :humidity_recurring_notify_duration, :integer, default: 60
    add_column :units, :humidity_notify_threshold, :float, default: 1.0
  end
end
