class AddTopAndBottomHumidityThresholdToCooler < ActiveRecord::Migration
  def change
    add_column :coolers, :top_humidity_threshold, :float, default: 81.0
    add_column :coolers, :bottom_humidity_threshold, :float, default: 74.0
  end
end
