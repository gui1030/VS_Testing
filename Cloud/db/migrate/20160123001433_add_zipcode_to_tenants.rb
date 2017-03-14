class AddZipcodeToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :zipcode, :string
  end
end
