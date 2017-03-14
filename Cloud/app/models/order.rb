# == Schema Information
#
# Table name: orders
#
#  id                     :integer          not null, primary key
#  unit_id                :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  tracking_number        :string(255)
#  fulfilled_by_id        :integer
#  fulfillment_started_at :datetime
#  fulfilled_at           :datetime
#  deleted_at             :datetime
#

class Order < ActiveRecord::Base
  FULFILLMENT_TIME_LIMIT = 15.minutes

  acts_as_paranoid

  belongs_to :unit
  belongs_to :fulfilled_by, class_name: 'User'

  has_many :line_items, (lambda do
    eager_load(:sensor).order("
      case
        when sensors.location_type = 'Hub' then 0
        when sensors.location_type = 'Cooler' then 1
        else 2
      end, sensors.id")
  end), dependent: :destroy

  validates :tracking_number, presence: true, allow_blank: false, if: :fulfilled?

  scope :fulfilled, -> { where.not(fulfilled_at: nil) }
  scope :unfulfilled, -> { where(fulfilled_at: nil) }
  scope :claimed_by, -> (user) { where(fulfilled_by: user).where('fulfillment_started_at > ? ', Time.current - FULFILLMENT_TIME_LIMIT) }
  scope :unclaimed, -> { where('fulfilled_by_id is null or fulfillment_started_at <= ?', Time.current - FULFILLMENT_TIME_LIMIT) }

  def fulfilled?
    fulfilled_at.present?
  end

  def claimed_by?(user)
    fulfilled_by == user && fulfillment_started_at > Time.current - FULFILLMENT_TIME_LIMIT
  end

  def unclaimed?
    fulfilled_by.nil? || fulfillment_started_at <= Time.current - FULFILLMENT_TIME_LIMIT
  end

  def deadline
    fulfillment_started_at && fulfillment_started_at + FULFILLMENT_TIME_LIMIT
  end
end
