class AddSubscriptionIdToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :subscription_id, :string
  end
end
