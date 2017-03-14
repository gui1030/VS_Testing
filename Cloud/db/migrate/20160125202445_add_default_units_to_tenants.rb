class AddDefaultUnitsToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :default_units, :integer, :default => 1
  end
end
