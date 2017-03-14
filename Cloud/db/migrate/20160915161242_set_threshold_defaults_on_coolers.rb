class SetThresholdDefaultsOnCoolers < ActiveRecord::Migration
  def change
    change_column_default :coolers, :bottom_temp_threshold, 0
    change_column_default :coolers, :top_temp_threshold, 5
  end
end
