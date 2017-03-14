class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :unit, index: true, foreign_key: true
      t.boolean :fulfilled, index: true
    end
  end
end
