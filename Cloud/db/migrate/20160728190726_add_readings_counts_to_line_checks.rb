class AddReadingsCountsToLineChecks < ActiveRecord::Migration
  def change
    add_column :line_checks, :readings_count, :integer, null: false, default: 0
    add_column :line_checks, :completed_count, :integer, null: false, default: 0
    add_column :line_checks, :successful_count, :integer, null: false, default: 0
  end
end
