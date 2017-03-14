class AddDeletedAtToLineCheckModels < ActiveRecord::Migration
  def change
    add_column :line_check_readings, :deleted_at, :datetime
    add_index :line_check_readings, :deleted_at

    add_column :line_check_schedules, :deleted_at, :datetime
    add_index :line_check_schedules, :deleted_at

    add_column :line_checks, :deleted_at, :datetime
    add_index :line_checks, :deleted_at
  end
end
