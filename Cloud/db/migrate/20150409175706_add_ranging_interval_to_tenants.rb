class AddRangingIntervalToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :ranging_interval, :integer, :default => 0
  end
end