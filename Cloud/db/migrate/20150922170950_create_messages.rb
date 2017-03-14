class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|

      t.references :tenant
      t.references :user
      t.timestamps null: false
    end
  end
end
