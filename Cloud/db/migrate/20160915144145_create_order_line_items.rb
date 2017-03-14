class CreateOrderLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :order, index: true, foreign_key: true
      t.references :sensor, index: true, foreign_key: true
    end
  end
end
