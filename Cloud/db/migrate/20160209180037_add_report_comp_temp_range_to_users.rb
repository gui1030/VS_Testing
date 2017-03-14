class AddReportCompTempRangeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :report_comp_temp_range, :boolean, :default => true
  end
end
