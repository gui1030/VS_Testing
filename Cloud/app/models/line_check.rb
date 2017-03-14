# == Schema Information
#
# Table name: line_checks
#
#  id                 :integer          not null, primary key
#  created_by_id      :integer
#  completed_by_id    :integer
#  completed_at       :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  line_check_list_id :integer
#  readings_count     :integer          default(0), not null
#  completed_count    :integer          default(0), not null
#  successful_count   :integer          default(0), not null
#  deleted_at         :datetime
#

class LineCheck < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :line_check_list
  belongs_to :created_by, class_name: 'User'
  belongs_to :completed_by, class_name: 'User'
  has_one :unit, through: :line_check_list
  has_many :line_check_readings, dependent: :destroy
  has_many :line_check_items, through: :line_check_readings

  validates :line_check_list, presence: true

  before_create :set_items

  alias_attribute :list, :line_check_list
  alias_attribute :readings, :line_check_readings
  alias_attribute :items, :line_check_items

  counter_culture :line_check_list, column_name: 'checks_count'

  private

  def set_items
    self.line_check_items = line_check_list.line_check_items
  end
end
