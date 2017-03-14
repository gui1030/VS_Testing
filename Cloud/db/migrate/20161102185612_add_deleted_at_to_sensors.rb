class AddDeletedAtToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :deleted_at, :datetime
    add_index :sensors, :deleted_at
  end
end
