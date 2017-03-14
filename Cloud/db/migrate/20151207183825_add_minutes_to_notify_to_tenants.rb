class AddMinutesToNotifyToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :minutes_to_notify, :integer, :default => 60
  end
end
