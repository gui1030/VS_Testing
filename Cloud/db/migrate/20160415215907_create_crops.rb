class CreateCrops < ActiveRecord::Migration
  def change
    create_table :crops do |t|
      t.string :facility_name 
      t.references :tenant, :null => false
      t.references :location, :null => false
      t.timestamps null: false
    end
  end
end
