class RemoveExcessTables < ActiveRecord::Migration
  def change
    drop_table :contacts
    drop_table :credit_cards
    drop_table :customers
    drop_table :districts
    drop_table :goliaths
    drop_table :invitations
    drop_table :links
    drop_table :logs
    drop_table :payments
    drop_table :plans
    drop_table :reports
    drop_table :subscribers
    drop_table :subscriptions
  end
end
