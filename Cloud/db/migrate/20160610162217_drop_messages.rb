class DropMessages < ActiveRecord::Migration
  def change
    drop_table :messages do |t|

      t.references :tenant
      t.references :user
      t.timestamps null: false
    end
  end
end
