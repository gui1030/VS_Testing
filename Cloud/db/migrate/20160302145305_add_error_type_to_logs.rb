class AddErrorTypeToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :error_type, :integer
  end
end
