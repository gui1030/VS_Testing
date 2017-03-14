class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :stripe_id
      t.attachment :logo
      t.timestamps null: false
    end
  end
end
