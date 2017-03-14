class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
    	t.integer :report_type, :null => false
        t.timestamps null: false
    end
  end
end
