class CreateGoliaths < ActiveRecord::Migration
  def change
    create_table :goliaths do |t|
    	
      t.timestamps null: false
    end
  end
end
