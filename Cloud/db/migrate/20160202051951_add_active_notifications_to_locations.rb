class AddActiveNotificationsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :active_notifications, :boolean, :default => true
  end
end
