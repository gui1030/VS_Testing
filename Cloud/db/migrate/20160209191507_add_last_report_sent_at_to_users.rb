class AddLastReportSentAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_report_sent_at, :datetime
  end
end
