# == Schema Information
#
# Table name: coolers
#
#  id                           :integer          not null, primary key
#  name                         :string(255)
#  top_temp_threshold           :float(24)        default(5.0)
#  bottom_temp_threshold        :float(24)        default(0.0)
#  unit_id                      :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  description                  :text(65535)
#  active_notifications         :boolean          default(TRUE)
#  last_threshold_sent          :datetime
#  deleted_at                   :datetime
#  top_humidity_threshold       :float(24)        default(81.0)
#  bottom_humidity_threshold    :float(24)        default(74.0)
#  humidity_notifications       :boolean          default(TRUE)
#  last_humidity_threshold_sent :datetime
#

class Cooler < ActiveRecord::Base
  acts_as_paranoid

  # Associations
  belongs_to :unit
  has_one :sensor, as: :location, dependent: :destroy
  has_many :sensor_readings, through: :sensor

  # Aliases
  alias_attribute :readings, :sensor_readings

  # Nested Attributes
  accepts_nested_attributes_for :sensor, update_only: true

  # Validations
  validates :unit, presence: true
  validates :name, presence: true, allow_blank: false, uniqueness: { scope: :unit_id }
  validates :top_temp_threshold, presence: true
  validates :bottom_temp_threshold, presence: true

  # Callbacks
  after_initialize :set_sensor
  before_validation :set_sensor_unit

  # Scopes
  scope :hot, -> { eager_load(:sensor).where('sensors.temp > coolers.top_temp_threshold') }
  scope :cold, -> { eager_load(:sensor).where('sensors.temp < coolers.bottom_temp_threshold') }
  scope :high_humidity, -> { eager_load(:sensor).where('sensors.humidity >         coolers.top_humidity_threshold') }
  scope :low_humidity, -> { eager_load(:sensor).where('sensors.humidity < coolers.bottom_humidity_threshold') }

  # Methods
  def temps_count
    sensor && sensor.readings_count || 0
  end

  def compliant_temps_count
    sensor && sensor.successful_readings_count || 0
  end

  def compliance
    temps_count.nonzero? && compliant_temps_count.to_f / temps_count.to_f
  end

  def success_range
    bottom_temp_threshold..top_temp_threshold
  end

  def notify_range
    bottom = bottom_temp_threshold - unit.notify_threshold
    top = top_temp_threshold + unit.notify_threshold
    bottom..top
  end

  def time_out_of_notify_range
    period = readings.history.take_while(&:out_of_notify_range?)
    (!period.empty? && (period.first.reading_time - period.last.reading_time)) || 0
  end

  def notify?
    active_notifications &&
      (last_threshold_sent.nil? ||
      ((Time.current - last_threshold_sent) > unit.recurring_notify_duration.minutes))
  end

  def stats(window)
    readings.in(window).select('min(sensor_readings.temp) as min,               max(sensor_readings.temp) as max,
    avg(sensor_readings.temp) as avg,
    min(sensor_readings.humidity) as hum_min,
    max(sensor_readings.humidity) as hum_max,
    avg(sensor_readings.humidity) as hum_avg,
    avg(success) as compliance').take
  end

  def to_s
    name
  end

  def hot?
    sensor.temp > top_temp_threshold
  end

  def cold?
    sensor.temp < bottom_temp_threshold
  end

  # Humidity Notifications
  def humidity_success_range
    bottom_humidity_threshold..top_humidity_threshold
  end

  def humidity_notify_range
    bottom = bottom_humidity_threshold - unit.humidity_notify_threshold
    top = top_humidity_threshold + unit.humidity_notify_threshold
    bottom..top
  end

  def humidity_notify?
    humidity_notifications &&
      (last_humidity_threshold_sent.nil? ||
      ((Time.current - last_humidity_threshold_sent) > unit.humidity_recurring_notify_duration.minutes))
  end

  def humidity_time_out_of_notify_range
    period = readings.history.take_while(&:humidity_out_of_notify_range?)
    (!period.empty? && (period.first.reading_time - period.last.reading_time)) || 0
  end

  def low_humidity?
    sensor.humidity < bottom_humidity_threshold
  end

  def high_humidity?
    sensor.humidity > top_humidity_threshold
  end

  private

  def set_sensor
    build_sensor if sensor.nil?
  end

  def set_sensor_unit
    sensor.unit = unit
  end
end
