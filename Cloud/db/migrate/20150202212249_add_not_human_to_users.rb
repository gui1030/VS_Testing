class AddNotHumanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :not_human, :boolean, :default => false
  end
end