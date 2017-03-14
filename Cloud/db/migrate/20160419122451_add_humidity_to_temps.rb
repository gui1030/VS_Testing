class AddHumidityToTemps < ActiveRecord::Migration
  def change
    add_column :temps, :humidity, :decimal
  end
end
