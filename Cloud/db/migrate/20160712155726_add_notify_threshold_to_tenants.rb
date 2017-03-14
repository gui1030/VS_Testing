class AddNotifyThresholdToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :notify_threshold, :float, default: 5
  end
end
