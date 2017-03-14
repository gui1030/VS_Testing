class AddSupportAccessToUsers < ActiveRecord::Migration
  def change
    add_column :users, :support_access, :boolean, :default => false
  end
end
