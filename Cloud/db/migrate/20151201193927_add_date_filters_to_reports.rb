class AddDateFiltersToReports < ActiveRecord::Migration
  def change
    add_column :reports, :datetime_start, :datetime
    add_column :reports, :datetime_end, :datetime
  end
end