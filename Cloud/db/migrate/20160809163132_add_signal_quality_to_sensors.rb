class AddSignalQualityToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :signal_quality, :integer
  end
end
