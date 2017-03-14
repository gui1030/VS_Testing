class AddDailyReportTimeToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :daily_report_time, :integer
  end
end
