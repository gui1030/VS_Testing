class CreateLineCheckLists < ActiveRecord::Migration
  def change
    create_table :line_check_lists do |t|
      t.references :tenant, index: true, foreign_key: true
      t.string :name
    end

    change_table :line_checks do |t|
      t.remove_references :tenant, index: true, foreign_key: true
      t.references :line_check_list, index: true, foreign_key: true
    end

    change_table :line_items do |t|
      t.remove_references :tenant, index: true, foreign_key: true
      t.references :line_check_list, index: true, foreign_key: true
    end

    change_table :line_schedules do |t|
      t.remove_references :tenant, index: true, foreign_key: true
      t.references :line_check_list, index: true, foreign_key: true
    end

    change_table :line_readings do |t|
      t.rename :line_check_id, :check_id
      t.rename :line_item_id, :item_id
    end

    drop_table :line_items_schedules, id: false do |t|
      t.references :line_item, index: true, foreign_key: true
      t.references :line_schedule, index: true, foreign_key: true
    end
  end
end
