class AddReportFrequencyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :report_frequency, :integer, :default => 0
  end
end
