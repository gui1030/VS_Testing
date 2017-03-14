class UnnamespaceLineCheckTables < ActiveRecord::Migration
  def change
    rename_table :line_check_list_checks, :line_checks
    rename_table :line_check_list_items, :line_check_items
    rename_table :line_check_list_readings, :line_check_readings
    rename_table :line_check_list_schedules, :line_check_schedules

    change_table :line_check_readings do |t|
      t.rename :check_id, :line_check_id
      t.rename :item_id, :line_check_item_id
    end
  end
end
