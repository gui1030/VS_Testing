class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_name
      t.string :auth_token
      t.string :device_id
      t.string :sim_id
      t.integer :battery
      t.integer :signal_quality
      t.references :tenant, :null => false
      t.timestamps null: false
    end

    add_index :devices, :device_id, :unique => true
    add_index :devices, :sim_id, :unique => true
  end
end
