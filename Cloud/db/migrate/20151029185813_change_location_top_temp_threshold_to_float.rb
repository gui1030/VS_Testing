class ChangeLocationTopTempThresholdToFloat < ActiveRecord::Migration
  def change
    change_column :locations, :top_temp_threshold, :float
  end
end