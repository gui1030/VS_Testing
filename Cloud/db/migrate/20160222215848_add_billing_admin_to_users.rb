class AddBillingAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :billing_admin, :boolean, :default => false
  end
end
