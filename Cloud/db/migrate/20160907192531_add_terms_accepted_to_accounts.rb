class AddTermsAcceptedToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :terms_accepted, :boolean
  end
end
