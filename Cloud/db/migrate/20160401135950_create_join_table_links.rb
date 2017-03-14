class CreateJoinTableLinks < ActiveRecord::Migration
  def change
  	create_table :links do |t|
      t.belongs_to :district, index: true
      t.belongs_to :tenant, index: true
    end
  end
end
