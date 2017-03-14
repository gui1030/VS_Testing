class AddItemsCountToLineCheckLists < ActiveRecord::Migration
  def change
    add_column :line_check_lists, :items_count, :integer, null: false, default: 0
  end
end
