class UpdateDefaultHumidityNotification < ActiveRecord::Migration
  def change
    change_column_default :coolers, :humidity_notifications, false
  end
end
