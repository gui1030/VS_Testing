class ChangeTenantDefaults < ActiveRecord::Migration
  def up
    change_column_default :tenants, :veritemp, true
  end

  def down
    change_column_default :tenants, :veritemp, false
  end
end
