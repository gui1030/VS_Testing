class RenameLocationsToCoolers < ActiveRecord::Migration
  def change
    rename_table :locations, :coolers
    rename_column :coolers, :location_name, :name
    rename_column :sensor_readings, :location_id, :cooler_id
  end
end
