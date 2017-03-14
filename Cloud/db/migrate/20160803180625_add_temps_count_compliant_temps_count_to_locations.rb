class AddTempsCountCompliantTempsCountToLocations < ActiveRecord::Migration

  def self.up

    add_column :locations, :temps_count, :integer, :null => false, :default => 0

    add_column :locations, :compliant_temps_count, :integer, :null => false, :default => 0

  end

  def self.down

    remove_column :locations, :temps_count

    remove_column :locations, :compliant_temps_count

  end

end
