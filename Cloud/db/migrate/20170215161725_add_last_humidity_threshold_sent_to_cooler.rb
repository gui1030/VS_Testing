class AddLastHumidityThresholdSentToCooler < ActiveRecord::Migration
  def change
    add_column :coolers, :last_humidity_threshold_sent, :datetime
  end
end
