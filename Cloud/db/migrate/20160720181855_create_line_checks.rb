class CreateLineChecks < ActiveRecord::Migration
  def change
    create_table :line_checks do |t|
      t.references :tenant, index: true, foreign_key: true
      t.references :created_by, index: true, foreign_key: false
      t.references :completed_by, index: true, foreign_key: false
      t.datetime :completed_at

      t.timestamps null: false
    end

    add_foreign_key :line_checks, :users, column: 'created_by_id'
    add_foreign_key :line_checks, :users, column: 'completed_by_id'
  end
end
