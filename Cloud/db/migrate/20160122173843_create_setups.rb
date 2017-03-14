class CreateSetups < ActiveRecord::Migration
  def change
    create_table :setups do |t|
      t.string :token
      t.datetime :token_sent_at 
      t.references :user, :presence => true
      t.references :tenant, :presence => true
      t.integer :progress, :default => 0
      t.timestamps null: false
    end
  end
end
