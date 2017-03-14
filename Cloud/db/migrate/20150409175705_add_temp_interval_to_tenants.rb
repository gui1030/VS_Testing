class AddTempIntervalToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :temp_interval, :integer, :default => 3600
  end
end