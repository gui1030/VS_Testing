class AddDistrictNameToDistricts < ActiveRecord::Migration
  def change
    add_column :districts, :district_name, :string, :null => false, :default => ""
  end
end
