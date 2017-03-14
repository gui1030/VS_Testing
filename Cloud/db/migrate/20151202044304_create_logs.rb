class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
    	t.string  :error_message
    	t.boolean :success
    	t.references :user
		t.references :tenant
        t.timestamps null: false
    end
  end
end
