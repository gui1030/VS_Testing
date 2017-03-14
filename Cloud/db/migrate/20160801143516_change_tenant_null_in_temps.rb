class ChangeTenantNullInTemps < ActiveRecord::Migration
  def change
    change_column :temps, :user_id, :integer, null: true
  end
end
