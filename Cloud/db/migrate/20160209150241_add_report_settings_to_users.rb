class AddReportSettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :report_time, :integer, :default => 6
    add_column :users, :report_weekday, :integer, :default => 0
    add_column :users, :report_day, :integer, :default => 1
    add_column :users, :report_max_temp, :boolean, :default => true
    add_column :users, :report_min_temp, :boolean, :default => true
    add_column :users, :report_avg_temp, :boolean, :default => true
    add_column :users, :report_compliance_temp, :boolean, :default => true
  end
end
