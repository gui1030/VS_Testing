class AddHumidityNotificationsToCooler < ActiveRecord::Migration
  def change
    add_column :coolers, :humidity_notifications, :boolean, default: true
  end
end
