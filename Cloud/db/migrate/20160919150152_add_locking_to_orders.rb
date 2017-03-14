class AddLockingToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :fulfilled_by_id, :integer
    add_index :orders, :fulfilled_by_id
    add_column :orders, :fulfillment_started_at, :datetime
    add_index :orders, :fulfillment_started_at
    add_column :orders, :fulfilled_at, :datetime
  end
end
