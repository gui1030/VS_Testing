class ChangeLocationBottomTempThresholdToFloat < ActiveRecord::Migration
  def change
    change_column :locations, :bottom_temp_threshold, :float
  end
end