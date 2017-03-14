class CreateSensors < ActiveRecord::Migration
  def change
    create_table :sensors do |t|

      t.string :sensorid, unique: true
      t.references :location, unique: true
      t.references :tenant
      t.timestamps null: false

    end
  end
end
