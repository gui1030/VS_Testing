class RenameTenantsToUnits < ActiveRecord::Migration
  def change
    rename_table :tenants, :units
    change_table :units do |t|
      t.rename :tenant_name, :name
    end

    rename_column :users, :tenant_id, :unit_id
    rename_column :coolers, :tenant_id, :unit_id
    rename_column :hubs, :tenant_id, :unit_id
    rename_column :sensors, :tenant_id, :unit_id
    rename_column :logs, :tenant_id, :unit_id
    rename_column :reports, :tenant_id, :unit_id
    rename_column :line_check_lists, :tenant_id, :unit_id
  end
end
