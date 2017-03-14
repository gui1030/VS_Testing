class AddLogoToTenants < ActiveRecord::Migration
  def up
    add_attachment :tenants, :logo
  end
end