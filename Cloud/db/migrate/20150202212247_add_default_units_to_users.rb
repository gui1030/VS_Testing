class AddDefaultUnitsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_units, :integer, :default => 0
  end
end