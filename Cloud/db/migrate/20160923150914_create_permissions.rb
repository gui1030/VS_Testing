class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :account_user, index: true
      t.references :unit, index: true, foreign_key: true
    end

    add_foreign_key :permissions, :users, column: :account_user_id
  end
end
