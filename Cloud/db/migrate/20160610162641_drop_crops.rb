class DropCrops < ActiveRecord::Migration
  def change
    drop_table :crops do |t|
      t.string :facility_name
      t.references :tenant, :null => false
      t.references :location, :null => false
      t.timestamps null: false
    end
  end
end
