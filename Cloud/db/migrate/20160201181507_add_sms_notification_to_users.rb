class AddSmsNotificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sms_notification, :boolean, :default => false
  end
end
