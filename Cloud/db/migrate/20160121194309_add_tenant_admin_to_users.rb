class AddTenantAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tenant_admin, :boolean, :default => false
  end
end
