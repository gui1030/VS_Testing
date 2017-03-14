class AddAddressToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :address, :string
  end
end
