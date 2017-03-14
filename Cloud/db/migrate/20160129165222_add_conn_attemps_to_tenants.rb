class AddConnAttempsToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :conn_attempts, :integer, :default => 2
  end
end
