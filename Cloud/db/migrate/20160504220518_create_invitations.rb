class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :tenant_name
      t.integer :step
      t.integer :tenant_id
      t.string :token
      t.integer :status

      t.timestamps null: false
    end
  end
end
