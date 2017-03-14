class AddEnableWizardToUsers < ActiveRecord::Migration
  def change
    add_column :users, :enable_wizard, :boolean, :default => true
  end
end
