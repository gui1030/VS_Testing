# == Schema Information
#
# Table name: line_check_schedules
#
#  id                 :integer          not null, primary key
#  time               :datetime         not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  line_check_list_id :integer
#  deleted_at         :datetime
#

class LineCheckSchedule < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :line_check_list
  has_one :unit, through: :line_check_list

  validates :time, presence: true
end
