class ChangeLogStringToText < ActiveRecord::Migration
  def change
    change_column :logs, :error_message, :text
  end
end