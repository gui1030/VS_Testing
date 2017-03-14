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

class Admin < User
  def registration_complete?
    true
  end

  def reads?(_model)
    true
  end

  def writes?(_model)
    true
  end
end
