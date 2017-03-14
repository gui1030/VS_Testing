class ChangeTempThresholdToFloat < ActiveRecord::Migration
  def change
    change_column :temps, :temp, :float
  end
end