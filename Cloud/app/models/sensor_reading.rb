# == Schema Information
#
# Table name: sensor_readings
#
#  id           :integer          not null, primary key
#  success      :boolean
#  reading_time :datetime         not null
#  temp         :float(24)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  battery      :integer
#  humidity     :decimal(10, )
#  parent_mac   :string(255)
#  rssi         :integer
#  sensor_id    :integer
#

class SensorReading < ActiveRecord::Base
  belongs_to :sensor
  belongs_to :parent, class_name: 'Sensor', primary_key: 'mac', foreign_key: 'parent_mac'
  has_one :cooler, through: :sensor, source_type: Cooler, source: :location
  has_one :unit, through: :sensor

  counter_culture :sensor, column_name: 'readings_count'
  counter_culture :sensor,
                  column_name: proc { |r| r.success && 'successful_readings_count' },
                  column_names: { ['sensor_readings.success = ?', true] => 'successful_readings_count' }
  counter_culture [:sensor, :unit],
                  column_name: proc { |r| r.cooler && 'temps_count' },
                  column_names: { ['sensors.location_type = ?', 'Cooler'] => 'temps_count' }
  counter_culture [:sensor, :unit],
                  column_name: proc { |r| r.cooler && r.success && 'compliant_temps_count' },
                  column_names: { ['sensors.location_type = ? and sensor_readings.success = ?', 'Cooler', true] => 'compliant_temps_count' }

  validates :reading_time, presence: true

  before_save :update_success, if: :cooler
  after_save :update_sensor

  scope :history, -> { order(reading_time: :desc) }
  scope :compliant, -> { where(success: true) }
  scope :compliance, -> { average(:success) }
  scope :in, ->(time) { where(reading_time: time) }

  def compliant?
    cooler && cooler.success_range.include?(temp) && cooler.humidity_success_range.include?(humidity)
  end

  def notify?
    cooler && cooler.notify? && out_of_notify_range?
  end

  def out_of_notify_range?
    cooler && !cooler.notify_range.include?(temp)
  end

  # humidity
  def humidity_compliant?
    cooler && cooler.humidity_success_range.include?(humidity)
  end

  def humidity_notify?
    cooler && cooler.humidity_notify? && humidity_out_of_notify_range?
  end

  def humidity_out_of_notify_range?
    cooler && !cooler.humidity_notify_range.include?(humidity)
  end

  private

  def update_success
    self.success = compliant?
    true
  end

  def update_sensor
    sensor.update(
      last_online: reading_time,
      parent_mac: parent_mac,
      temp: temp,
      humidity: humidity,
      battery: battery,
      rssi: rssi
    ) unless sensor.last_online && sensor.last_online > reading_time
  end
end
