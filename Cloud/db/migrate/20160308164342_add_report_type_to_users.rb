class AddReportTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :report_type, :integer, :default => 0
  end
end
