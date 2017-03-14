class ChangeUserDefaults < ActiveRecord::Migration
  def up
    change_column_default :users, :time_zone, 'Eastern Time (US & Canada)'
    change_column_default :users, :default_app, 1
    change_column_default :users, :default_units, 1
  end

  def down
    change_column_default :users, :time_zone, nil
    change_column_default :users, :default_app, 0
    change_column_default :users, :default_units, 0
  end
end
