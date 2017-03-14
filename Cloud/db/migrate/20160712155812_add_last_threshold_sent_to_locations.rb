class AddLastThresholdSentToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :last_threshold_sent, :datetime
  end
end
