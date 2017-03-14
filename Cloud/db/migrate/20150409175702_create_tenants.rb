class CreateTenants < ActiveRecord::Migration
  def change
    create_table :tenants do |t|

      t.string :tenant_name
      t.integer :wash_timer
      t.integer :dispense_timer
      t.string :city
      t.string :state
      t.string :institution
      t.integer :instance_type, :default => 0
      t.timestamps null: false
      t.boolean :active, :default => true
      t.boolean :vericlean, :default => false
      t.boolean :veritemp, :default => false
      t.boolean :veritrack, :default => false
       
    end

  end
end
