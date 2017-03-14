class AddLastThresholdSentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_threshold_sent, :datetime
  end
end
