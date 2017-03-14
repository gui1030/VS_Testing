class AddHumidToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :top_humid_threshold, :integer
    add_column :locations, :bottom_humid_threshold, :integer
  end
end
