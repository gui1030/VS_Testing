class CreateLineSchedules < ActiveRecord::Migration
  def change
    create_table :line_schedules do |t|
      t.references :tenant, index: true, foreign_key: true
      t.datetime :time, index: true, null: false

      t.timestamps null: false
    end

    create_table :line_items_schedules, id: false do |t|
      t.references :line_item, index: true, foreign_key: true
      t.references :line_schedule, index: true, foreign_key: true
    end
  end
end
