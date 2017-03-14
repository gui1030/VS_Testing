class AddLogoToDistricts < ActiveRecord::Migration
  def change
    add_attachment :districts, :logo
  end
end
