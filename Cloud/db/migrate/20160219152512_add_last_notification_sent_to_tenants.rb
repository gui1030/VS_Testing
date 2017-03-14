class AddLastNotificationSentToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :last_notification_sent, :datetime
  end
end
