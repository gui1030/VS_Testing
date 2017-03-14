class AddCheckCountToLineCheckLists < ActiveRecord::Migration
  def change
    add_column :line_check_lists, :checks_count, :integer, null: false, default: 0
  end
end
