class AddVeritempPacketTypeToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :veritemp_packet_type, :integer, :default => 0
  end
end
