class AddLastDailyReportSentToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :last_daily_report_sent, :datetime
  end
end
