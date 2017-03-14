class UpdateDefaultHumidityThreshold < ActiveRecord::Migration
  def change
   change_column_default :coolers, :top_humidity_threshold, 99.0
   change_column_default :coolers, :bottom_humidity_threshold, 1.0
  end
end
