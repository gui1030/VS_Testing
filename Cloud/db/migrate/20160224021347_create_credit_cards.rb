class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
		t.integer :tenant_id
        t.string :last4digits
        t.integer :expiration_month
        t.integer :expiration_year
        t.timestamps null: false
    end
  end
end
