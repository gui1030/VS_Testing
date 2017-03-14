class AddGraphTypeDefaultToUsers < ActiveRecord::Migration
  def change
    add_column :users, :graph_type_default, :integer, :default => 0
  end
end