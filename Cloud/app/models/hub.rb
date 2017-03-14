# == Schema Information
#
# Table name: hubs
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  particle_id :string(255)
#  unit_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  rssi        :integer
#  last_online :datetime
#  battery     :integer
#  deleted_at  :datetime
#

class Hub < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :unit
  has_one :sensor, as: :location, dependent: :destroy, autosave: true
  has_many :hub_locations, dependent: :destroy

  enum cell_carrier: [:Particle, :ATT]

  alias_attribute :locations, :hub_locations

  validates :unit, presence: true
  validates :name, presence: true, allow_blank: false
  validates :particle_id, presence: true, allow_blank: true, uniqueness: true

  after_initialize :set_sensor

  before_save :rename_device, if: :name_changed? if Figaro.env.particle_token

  CELL_CARRIER = { 'Particle' => 'Particle',
                   'AT&T' => 'ATT' }.freeze

  def last_online
    return nil unless particle_id.present?
    @last_online ||= Time.zone.parse(device.last_heard)
  end

  def rssi
    return nil unless particle_id.present?
    return nil unless device.connected?
    device.get(:rssi) if device.variables.include?(:rssi)
  end

  def battery
    return nil unless particle_id.present?
    return nil unless device.connected?
    device.get(:battery) if device.variables.include?(:battery)
  end

  def offline?
    last_online && last_online < Time.current - 1.hour
  end

  def to_s
    name
  end

  def registered?
    particle_id.present?
  end

  def device
    @device ||= Particle.device(particle_id)
  end

  def restart
    call_particle_function 'restart'
  end

  def paranoia_destroy_attributes
    super.merge(particle_id: '')
  end

  private

  def rename_device
    return true unless particle_id.present?
    success = device.rename name.strip.gsub(/[^\w]/, '_')
    errors.add :name, 'is invalid' unless success
    success
  rescue Particle::Error
    errors.add :base, 'An error occurred with the Particle Cloud'
    false
  end

  def call_particle_function(f, arg = '')
    success = device.call(f, arg) >= 0
    errors.add :base, 'Remote Command Failed' unless success
    success
  rescue Particle::Error
    errors.add :base, 'An error occurred with the Particle Cloud'
    false
  end

  def set_sensor
    build_sensor(unit: unit) if sensor.nil?
  end
end
