class AddReportNameToReports < ActiveRecord::Migration
  def change
    add_column :reports, :report_name, :string
  end
end