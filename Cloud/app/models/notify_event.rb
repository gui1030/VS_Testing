# == Schema Information
#
# Table name: notify_events
#
#  id            :integer          not null, primary key
#  message       :text(65535)
#  notify_type   :integer
#  sent_at       :datetime
#  user_id       :integer
#  subscriber_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class NotifyEvent < ActiveRecord::Base
  belongs_to :user
  enum notify_type: [:email, :sms]
  default_scope { order(sent_at: :desc) }
end
