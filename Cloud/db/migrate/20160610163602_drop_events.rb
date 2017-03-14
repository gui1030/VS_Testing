class DropEvents < ActiveRecord::Migration
  def change
    drop_table :events do |t|
      t.boolean :success
      t.references :user, :null => false
      t.references :location, :null => false
      t.datetime :entry_time
      t.datetime :exit_time
      t.references :tenant
      t.integer :event_type, :null => false
      t.timestamps null: false
    end
  end
end
