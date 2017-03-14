# == Schema Information
#
# Table name: line_items
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  sensor_id  :integer
#  deleted_at :datetime
#

class LineItem < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :order
  belongs_to :sensor, -> { with_deleted }
end
