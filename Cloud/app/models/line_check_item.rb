# == Schema Information
#
# Table name: line_check_items
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  temp_high          :float(24)
#  temp_low           :float(24)
#  order              :integer
#  description        :text(65535)
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  line_check_list_id :integer
#

class LineCheckItem < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :line_check_list
  has_one :unit, through: :line_check_list
  has_many :line_check_readings
  has_many :line_checks, through: :line_check_readings

  validates :name, presence: true, allow_blank: false
  validates :temp_high, :temp_low, presence: true

  counter_culture :line_check_list, column_name: 'items_count'

  def temp_range
    temp_low..temp_high
  end
end
