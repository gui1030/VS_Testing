class CreateLineReadings < ActiveRecord::Migration
  def change
    create_table :line_readings do |t|
      t.references :line_check, index: true, foreign_key: true
      t.references :line_item, index: true, foreign_key: true
      t.float :temp
      t.boolean :success

      t.timestamps null: false
    end
  end
end
