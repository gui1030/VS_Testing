class AddTempActiveToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :temp_active, :boolean, :default => true
    add_column :tenants, :humid_active, :boolean, :default => false
    add_column :tenants, :light_active, :boolean, :default => false
    add_column :tenants, :battery_active, :boolean, :default => false
  end
end
