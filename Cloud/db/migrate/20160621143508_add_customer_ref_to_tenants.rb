class AddCustomerRefToTenants < ActiveRecord::Migration
  def change
    add_reference :tenants, :customer, index: true, foreign_key: true
  end
end
