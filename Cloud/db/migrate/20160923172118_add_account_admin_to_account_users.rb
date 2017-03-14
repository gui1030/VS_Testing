class AddAccountAdminToAccountUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_admin, :boolean
  end
end
