class AddParentNodeToTemps < ActiveRecord::Migration
  def change
    add_column :temps, :parent_node, :string
    add_column :temps, :signal_dbm, :integer
  end
end
