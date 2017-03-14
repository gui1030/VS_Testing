class AddImportedToTemps < ActiveRecord::Migration
  def change
    add_column :temps, :imported, :boolean, :default => false
  end
end
