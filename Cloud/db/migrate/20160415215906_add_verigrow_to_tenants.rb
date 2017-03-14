class AddVerigrowToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :verigrow, :boolean, :default => false
  end
end
