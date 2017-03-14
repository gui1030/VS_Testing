class AddDeletedAtToLineCheckLists < ActiveRecord::Migration
  def change
    add_column :line_check_lists, :deleted_at, :datetime
    add_index :line_check_lists, :deleted_at
  end
end
