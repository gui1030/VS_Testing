class AddDistrictToTenants < ActiveRecord::Migration
  def change
    add_reference :tenants, :district, index: true, foreign_key: true
  end
end
