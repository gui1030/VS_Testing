class AddLinkedToInvitations < ActiveRecord::Migration
  def change
  	add_column :invitations, :linked, :boolean, :default => false
  end
end
