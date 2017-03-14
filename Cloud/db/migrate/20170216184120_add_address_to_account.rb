class AddAddressToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :city, :string
    add_column :accounts, :state, :string
    add_column :accounts, :zipcode, :string
    add_column :accounts, :address, :string
    add_column :accounts, :address1, :string
  end
end
