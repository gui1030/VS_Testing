class AddVeritempPacketTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :veritemp_packet_type, :integer, :default => 0
  end
end
