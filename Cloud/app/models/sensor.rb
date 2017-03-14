# == Schema Information
#
# Table name: sensors
#
#  id                        :integer          not null, primary key
#  mac                       :string(255)
#  location_id               :integer
#  unit_id                   :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  last_online               :datetime
#  name                      :string(255)
#  location_type             :string(255)
#  parent_mac                :string(255)
#  battery                   :integer
#  readings_count            :integer          default(0), not null
#  successful_readings_count :integer          default(0), not null
#  rssi                      :integer
#  temp                      :float(24)
#  humidity                  :float(24)
#  deleted_at                :datetime
#

class Sensor < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :unit
  belongs_to :location, polymorphic: true
  belongs_to :parent, class_name: 'Sensor', primary_key: 'mac', foreign_key: 'parent_mac'
  has_many :sensor_readings, dependent: :destroy

  alias_attribute :readings, :sensor_readings

  scope :repeaters, -> { where(location: nil) }
  scope :offline, -> { where('last_online < ?', Time.current - 1.hour) }

  validates :mac, uniqueness: true, allow_nil: true

  before_save :nil_mac

  def offline?
    last_online && last_online < Time.current - 2.hours
  end

  def name
    (super.present? && super) || (location.present? && location.name) || mac
  end

  def to_s
    name
  end

  def paranoia_destroy_attributes
    super.merge(mac: nil)
  end

  private

  def nil_mac
    self.mac = nil if mac.blank?
  end
end
