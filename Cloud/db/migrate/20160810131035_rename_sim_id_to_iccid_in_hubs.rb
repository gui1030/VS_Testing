class RenameSimIdToIccidInHubs < ActiveRecord::Migration
  def change
    rename_column :hubs, :sim_id, :iccid
  end
end
