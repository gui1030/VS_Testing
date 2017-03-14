# == Schema Information
#
# Table name: line_check_readings
#
#  id                 :integer          not null, primary key
#  line_check_id      :integer
#  line_check_item_id :integer
#  temp               :float(24)
#  success            :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  deleted_at         :datetime
#

class LineCheckReading < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :line_check
  belongs_to :line_check_item, -> { with_deleted }
  has_one :unit, through: :line_check

  validates :line_check, presence: true
  validates :line_check_item, presence: true

  delegate :name, to: :line_check_item

  before_save do
    self.success = line_check_item.temp_range.include? temp
    true
  end

  counter_culture :line_check, column_name: 'readings_count'
  counter_culture :line_check, column_name: proc { |model| model.temp ? 'completed_count' : nil },
                               column_names: { ['line_check_readings.temp is not ?', nil] => 'completed_count' }
  counter_culture :line_check, column_name: proc { |model| model.success ? 'successful_count' : nil },
                               column_names: { ['line_check_readings.success = ?', true] => 'successful_count' }

  alias_attribute :item, :line_check_item
end
