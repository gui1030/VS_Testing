class AddWalkInToCoolers < ActiveRecord::Migration
  def change
    add_column :coolers, :walk_in, :boolean
  end
end
