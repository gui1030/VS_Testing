class AddRecurringNotifyDurationToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :recurring_notify_duration, :integer, :default => 60
  end
end
