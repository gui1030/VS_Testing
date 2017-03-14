# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  firstname              :string(255)
#  lastname               :string(255)
#  time_zone              :string(255)      default("Eastern Time (US & Canada)")
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  unit_id                :integer
#  created_at             :datetime
#  updated_at             :datetime
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  authentication_token   :string(255)
#  default_units          :integer          default(1)
#  email_notification     :boolean          default(TRUE)
#  daily_notification     :boolean          default(TRUE)
#  phone                  :string(255)
#  sms_notification       :boolean          default(FALSE)
#  report_frequency       :integer          default(0)
#  report_time            :integer          default(6)
#  report_weekday         :integer          default(0)
#  report_day             :integer          default(1)
#  last_report_sent_at    :datetime
#  support_access         :boolean          default(FALSE)
#  device_last_online     :datetime
#  report_type            :integer          default(0)
#  email_token            :string(255)
#  probe_enabled          :boolean
#  type                   :string(255)
#  account_id             :integer
#  account_admin          :boolean
#

class User < ActiveRecord::Base
  has_many :notify_events, dependent: :destroy

  has_attached_file :avatar,
                    styles: { medium: '300x300#', thumb: '100x100#' },
                    default_url: ->(avatar) { avatar.instance.set_default_url }

  # Enums
  enum default_units: [:metric, :english]
  enum report_frequency: [:daily, :weekly, :bi_weekly, :monthly]

  # Validations
  validates :type, presence: true
  validates :phone, format: { with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/,
                              allow_blank: true,
                              message: 'field requires format (XXX) XXX-XXXX' }
  validates :phone, presence: true, if: :sms_notification
  validates_attachment_content_type :avatar, content_type: %r{\Aimage/.*\Z}
  validates :email, presence: true, allow_blank: false, uniqueness: true

  # Constants
  UNITS = { 'Metric' => 'metric',
            'English' => 'english' }.freeze

  REPORT_FREQUENCY = { 'Daily' => 'daily',
                       'Weekly' => 'weekly',
                       'Bi-Weekly' => 'bi_weekly',
                       'Monthly' => 'monthly' }.freeze

  REPORT_FREQUENCY_LABEL = { 'daily' => 'Daily',
                             'weekly' => 'Weekly',
                             'bi_weekly' => 'Bi-Weekly',
                             'monthly' => 'Monthly' }.freeze

  REPORT_FREQUENCY_TEXT = { 'daily' => '24 hours',
                            'weekly' => 'week',
                            'bi_weekly' => 'two weeks',
                            'monthly' => 'month' }.freeze

  REPORT_WEEKDAY = { 'Monday' => 0,
                     'Tuesday' => 1,
                     'Wednesday' => 2,
                     'Thursday' => 3,
                     'Friday' => 4,
                     'Saturday' => 5,
                     'Sunday' => 6 }.freeze

  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable.
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :timeoutable,
         :lockable,
         :confirmable

  ### DEVISE CONFIRMATION HELPER METHODS
  def only_if_unconfirmed
    pending_any_confirmation { yield }
  end

  # new function to set the password without knowing the current password
  # used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # new function to return whether a password has been set
  def no_password?
    encrypted_password.blank?
  end

  def password_required?
    # Password is required if it is being set, but not for new records
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  def password_match?
    errors[:password] << "can't be blank" if password.blank?
    errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    errors[:password_confirmation] << 'does not match password' if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  def self.report_day
    hash = (1..27).each_with_object({}) { |i, a| a[i] = i.to_s }
    hash['End of Month'] = 28
    hash
  end

  def set_default_url
    ActionController::Base.helpers.asset_path('missing.png')
  end

  def admin?
    is_a? Admin
  end

  def reads?(_model)
    raise NotImplementedError
  end

  def writes?(_model)
    raise NotImplementedError
  end

  def registration_complete?
    true
  end

  def phone_e164
    "+1#{phone.gsub(/[^0-9]/, '')}"
  end

  def report?(now)
    Time.use_zone(time_zone) do
      now = now.in_time_zone
      hour = now.hour
      weekday = (now.wday - 1) % 7
      day = now.day

      case report_frequency
      when 'daily'
        hour == report_time
      when 'weekly'
        weekday == report_weekday && hour == report_time
      when 'bi_weekly'
        weekday == report_weekday && hour == report_time && !report_sent_since?(now, 13.days)
      when 'monthly'
        day == report_day_for(now) && hour == report_time
      end
    end
  end

  def report_sent_since?(time, duration)
    last_report_sent_at && ((time - last_report_sent_at) < duration)
  end

  def report_start_time(now)
    case report_frequency
    when 'daily' then now - 1.day
    when 'weekly' then now - 1.week
    when 'bi_weekly' then now - 2.weeks
    when 'monthly' then now - 1.month
    end
  end

  def report_day_for(now)
    case report_day
    when 28 then now.end_of_month.day
    else report_day
    end
  end

  def notifications?
    email_notification || sms_notification
  end

  def name
    "#{firstname} #{lastname}"
  end

  def to_s
    name
  end

  protected

  def unit_for(model)
    if model.is_a? Unit
      model
    elsif model.respond_to? :unit
      model.unit
    end
  end

  def account_for(model)
    if model.is_a? Account
      model
    elsif model.respond_to? :account
      model.account
    elsif model.respond_to? :unit
      model.unit.account
    end
  end
end
