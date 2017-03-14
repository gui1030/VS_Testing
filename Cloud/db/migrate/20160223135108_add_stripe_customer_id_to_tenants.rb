class AddStripeCustomerIdToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :stripe_customer_id, :string
  end
end
