# == Schema Information
#
# Table name: units
#
#  id                                 :integer          not null, primary key
#  name                               :string(255)
#  city                               :string(255)
#  state                              :string(255)
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  logo_file_name                     :string(255)
#  logo_content_type                  :string(255)
#  logo_file_size                     :integer
#  logo_updated_at                    :datetime
#  address                            :string(255)
#  address1                           :string(255)
#  zipcode                            :string(255)
#  recurring_notify_duration          :integer          default(60)
#  notify_threshold                   :float(24)        default(5.0)
#  users_count                        :integer          default(0), not null
#  probe_enabled                      :boolean
#  temps_count                        :integer          default(0), not null
#  compliant_temps_count              :integer          default(0), not null
#  account_id                         :integer
#  deleted_at                         :datetime
#  humidity_recurring_notify_duration :integer          default(60)
#  humidity_notify_threshold          :float(24)        default(1.0)
#

class Unit < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :account
  has_many :users, class_name: 'UnitUser', dependent: :destroy
  has_many :coolers, dependent: :destroy, inverse_of: :unit
  has_many :hubs, dependent: :destroy
  has_many :sensors, dependent: :destroy
  has_many :line_check_lists, dependent: :destroy
  has_many :sensor_readings, through: :coolers
  has_many :orders, dependent: :destroy, autosave: true
  has_many :permissions, dependent: :destroy
  has_many :account_users, through: :permissions

  enum default_units: [:metric, :english]

  has_attached_file :logo,
                    styles: { medium: '300x300>', thumb: '100x100>' },
                    default_url: ->(logo) { logo.instance.set_default_url }

  alias_attribute :readings, :sensor_readings

  validates_attachment_content_type :logo, content_type: %r{\Aimage/.*\Z}
  validates :name, presence: true, allow_blank: false

  before_create :build_hub

  TIME_TO_INT = { '12:00am' => 0,
                  '1:00am' => 1,
                  '2:00am' => 2,
                  '3:00am' => 3,
                  '4:00am' => 4,
                  '5:00am' => 5,
                  '6:00am' => 6,
                  '7:00am' => 7,
                  '8:00am' => 8,
                  '9:00am' => 9,
                  '10:00am' => 10,
                  '11:00am' => 11,
                  '12:00pm' => 12,
                  '1:00pm' => 13,
                  '2:00pm' => 14,
                  '3:00pm' => 15,
                  '4:00pm' => 16,
                  '5:00pm' => 17,
                  '6:00pm' => 18,
                  '7:00pm' => 19,
                  '8:00pm' => 20,
                  '9:00pm' => 21,
                  '10:00pm' => 22,
                  '11:00pm' => 23 }.freeze

  def primary_contact
    users.find_by(primary_contact: true)
  end

  def locale
    "#{city}, #{state}"
  end

  def subscribers
    users
  end

  def account_subscribers
    account_users + account.users.select(&:account_admin?)
  end

  def daily_report_data(window)
    temps.in(window).select('min(temp) as min, max(temp) as max, avg(temp) as avg, avg(success) as compliance')
  end

  def compliance
    temps_count && compliant_temps_count.to_f / temps_count
  end

  def set_default_url
    ActionController::Base.helpers.asset_path('verisolutions_logo_black_small.png')
  end

  def to_s
    name
  end

  def alerts
    return @alerts if @alerts
    hot = coolers.hot.map { |cooler| [:hot, cooler] }
    cold = coolers.cold.map { |cooler| [:cold, cooler] }
    offline = sensors.offline.map { |sensor| [:offline, sensor] }
    high_humidity = coolers.high_humidity.map { |cooler| [:high_humidity, cooler] }
    low_humidity = coolers.low_humidity.map { |cooler| [:low_humidity, cooler] }
    @alerts = hot + cold + offline + high_humidity + low_humidity
  end

  def alerts?
    !alerts.empty?
  end

  def build_initial_order
    order = orders.build
    order.line_items.build(sensors.map { |sensor| { sensor: sensor } })
  end

  private

  def build_hub
    hubs.build name: "#{name} Hub"
  end
end
