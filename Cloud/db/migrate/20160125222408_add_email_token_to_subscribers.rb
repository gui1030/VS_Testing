class AddEmailTokenToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :email_token, :string
    add_index :subscribers, :email_token, unique: true
  end
end
