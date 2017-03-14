class ChangeDeviceDefaultValues < ActiveRecord::Migration
  def up
    change_column_default :devices, :cell_carrier, 1
  end

  def down
    change_column_default :devices, :cell_carrier, 1
  end
end
