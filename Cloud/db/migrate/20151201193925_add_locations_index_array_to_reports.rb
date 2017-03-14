class AddLocationsIndexArrayToReports < ActiveRecord::Migration
  def change
    add_column :reports, :locations_array, :string, array: true, default: []
  end
end