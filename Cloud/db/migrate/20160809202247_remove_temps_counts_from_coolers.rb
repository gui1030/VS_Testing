class RemoveTempsCountsFromCoolers < ActiveRecord::Migration
  def change
    remove_column :coolers, :temps_count, :integer, null: false, default: 0
    remove_column :coolers, :compliant_temps_count, :integer, null: false, default: 0
  end
end
