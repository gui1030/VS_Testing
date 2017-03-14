class AddReadingsCountSuccessfulReadingsCountToSensors < ActiveRecord::Migration

  def self.up

    add_column :sensors, :readings_count, :integer, :null => false, :default => 0

    add_column :sensors, :successful_readings_count, :integer, :null => false, :default => 0

  end

  def self.down

    remove_column :sensors, :readings_count

    remove_column :sensors, :successful_readings_count

  end

end
