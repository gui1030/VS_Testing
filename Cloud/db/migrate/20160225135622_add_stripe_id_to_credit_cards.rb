class AddStripeIdToCreditCards < ActiveRecord::Migration
  def change
    add_column :credit_cards, :stripe_id, :string
    remove_column :credit_cards, :last4digits
    remove_column :credit_cards, :expiration_month
    remove_column :credit_cards, :expiration_year
  end
end
