class CreateTemps < ActiveRecord::Migration
  def change
    create_table :temps do |t|
      t.boolean :success
      t.references :user, :null => false
      t.references :location, :null => false
      t.datetime :reading_time, :null => false
      t.references :tenant
      t.integer :temp, :null => false
      t.timestamps null: false

    end
  end
end
