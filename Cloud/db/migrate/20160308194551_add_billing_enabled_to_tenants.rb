class AddBillingEnabledToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :billing_enabled, :boolean, :default => false
  end
end
