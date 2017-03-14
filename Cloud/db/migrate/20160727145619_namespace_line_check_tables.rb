class NamespaceLineCheckTables < ActiveRecord::Migration
  def change
    rename_table :line_checks, :line_check_list_checks
    rename_table :line_items, :line_check_list_items
    rename_table :line_readings, :line_check_list_readings
    rename_table :line_schedules, :line_check_list_schedules
  end
end
