class ChangeGpsColumnTypes < ActiveRecord::Migration
  def change
    change_table :hub_locations do |t|
      t.change :altitude, :integer
      t.change :velocity, :float
    end
  end
end
