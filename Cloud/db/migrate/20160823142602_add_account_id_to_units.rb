class AddAccountIdToUnits < ActiveRecord::Migration
  def change
    add_reference :units, :account, index: true, foreign_key: true
  end
end
