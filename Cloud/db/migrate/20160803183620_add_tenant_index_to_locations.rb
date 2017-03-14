class AddTenantIndexToLocations < ActiveRecord::Migration
  def change
    add_index :locations, :tenant_id
  end
end
