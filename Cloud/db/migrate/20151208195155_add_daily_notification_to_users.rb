class AddDailyNotificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :daily_notification, :boolean, :default => true
  end
end
