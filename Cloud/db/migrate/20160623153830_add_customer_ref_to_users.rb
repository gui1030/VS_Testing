class AddCustomerRefToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :customer, index: true, foreign_key: true
  end
end
