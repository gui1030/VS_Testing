class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.boolean     :active, :default => true
      t.boolean     :email_notifications, :default => true
      t.boolean     :phone_notifications, :default => true
      t.string 		:firstname
      t.string 		:lastname
      t.string 		:email,  :null => false, :default => ""
      t.references  :tenant, :presence => true
      t.string  	:phone
      t.datetime :last_threshold_sent
      t.timestamps  null: false
    end
  end
end
