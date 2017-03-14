class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :tenant, index: true, foreign_key: true
      t.string :name
      t.float :temp_high
      t.float :temp_low
      t.integer :order
      t.text :description
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
