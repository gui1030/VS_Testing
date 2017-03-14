class AddDeletedAtToCoolers < ActiveRecord::Migration
  def change
    add_column :coolers, :deleted_at, :datetime
    add_index :coolers, :deleted_at
  end
end
