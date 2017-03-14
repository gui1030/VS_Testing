class AddLocationIndexToTemps < ActiveRecord::Migration
  def change
    add_index :temps, :location_id
  end
end
