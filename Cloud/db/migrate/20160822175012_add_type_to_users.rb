class AddTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :type, :string
    add_index :users, [:id, :type], unique: true, using: :btree
  end
end
