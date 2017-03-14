class CreateNotifyEventsTable < ActiveRecord::Migration
  def change
  	create_table :notify_events do |t|
    	t.text :message
        t.integer :notify_type
        t.datetime :sent_at
        t.integer :user_id
        t.integer :subscriber_id
        t.timestamps null: false
    end
  end
end
 