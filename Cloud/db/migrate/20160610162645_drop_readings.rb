class DropReadings < ActiveRecord::Migration
  def change
    drop_table :readings do |t|
      t.decimal :temp
      t.decimal  :humidity
      t.decimal :lux
      t.decimal :pressure
      t.decimal :co2
      t.integer :battery
      t.references :crop, :null => false
      t.references :tenant, :null => false
      t.datetime :reading_time, :null => false
      t.timestamps null: false
    end
  end
end
