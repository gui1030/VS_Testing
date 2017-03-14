class AddImplementationGuideToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invitation, :boolean
  end
end
