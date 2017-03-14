class AddLuxToTemps < ActiveRecord::Migration
  def change
    add_column :temps, :lux, :decimal
  end
end
