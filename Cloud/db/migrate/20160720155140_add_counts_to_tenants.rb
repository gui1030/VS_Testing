class AddCountsToTenants < ActiveRecord::Migration
  def up
    add_column :tenants, :users_count, :integer, null: false, default: 0
    add_column :tenants, :issues_count, :integer, null: false, default: 0
  end

  def down
    remove_column :tenants, :users_count
    remove_column :tenants, :issues_count
  end
end
