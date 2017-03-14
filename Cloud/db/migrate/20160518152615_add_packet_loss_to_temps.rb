class AddPacketLossToTemps < ActiveRecord::Migration
  def change
    add_column :temps, :packet_loss, :integer
  end
end
