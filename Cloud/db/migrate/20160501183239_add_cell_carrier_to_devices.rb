class AddCellCarrierToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :cell_carrier, :integer
  end
end
