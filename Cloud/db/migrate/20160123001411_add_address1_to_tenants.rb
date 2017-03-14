class AddAddress1ToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :address1, :string
  end
end
