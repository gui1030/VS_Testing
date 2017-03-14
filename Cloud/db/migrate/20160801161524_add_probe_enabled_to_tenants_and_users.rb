class AddProbeEnabledToTenantsAndUsers < ActiveRecord::Migration
  def change
    add_column :tenants, :probe_enabled, :boolean
    add_column :users, :probe_enabled, :boolean
  end
end
