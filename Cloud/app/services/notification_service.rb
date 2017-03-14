class NotificationService
  class << self
    include TempsHelper
    include ActionView::Helpers::DateHelper
    include ActionView::Helpers::NumberHelper

    def check_notifications(readings)
      Array(readings).select(&:notify?).map(&:cooler).each do |cooler|
        cooler_notifications(cooler.reload)
      end
    end

    def cooler_notifications(cooler)
      cooler.update! last_threshold_sent: Time.current
      users = cooler.unit.subscribers + cooler.unit.account_subscribers
      users.each { |user| user_cooler_notifications(user, cooler) }
    end

    # Checking for out of range humidity
    def check_humidity_notifications(readings)
      Array(readings).select(&:humidity_notify?).map(&:cooler).each do |cooler|
        humidity_notifications(cooler.reload)
      end
    end

    # Sending humidity notifications
    def humidity_notifications(cooler)
      cooler.update! last_humidity_threshold_sent: Time.current
      users = cooler.unit.subscribers + cooler.unit.account_subscribers
      users.each { |user| user_humidity_notifications(user, cooler) }
    end

    private

    # Temperature notifications
    def user_cooler_notifications(user, cooler)
      user_sms_cooler_notifications(user, cooler) if user.sms_notification
      user_email_cooler_notifications(user, cooler) if user.email_notification
    end

    def user_email_cooler_notifications(user, cooler)
      if cooler.hot?
        user.notify_events.email.create! message: "#{cooler} is too hot", sent_at: Time.current
      elsif cooler.cold?
        user.notify_events.email.create! message: "#{cooler} is too cold", sent_at: Time.current
      end
      ApplicationMailer.cooler_notifications(user, cooler).deliver_now
    end

    def user_sms_cooler_notifications(user, cooler)
      if cooler.hot?
        user.notify_events.sms.create! message: "#{cooler} is too hot", sent_at: Time.current
      elsif cooler.cold?
        user.notify_events.sms.create! message: "#{cooler} is too cold", sent_at: Time.current
      end
      thresh = scale_temp_for(user, cooler.unit.notify_threshold)
      units = temp_units_for(user)
      time_out = distance_of_time_in_words(cooler.time_out_of_notify_range)
      current = convert_temp_for(user, cooler.sensor.temp)
      body = "#{cooler} (#{cooler.unit}) has been more than #{thresh} #{units} out of range for #{time_out}. Current temp is #{current} #{units}"
      send_sms(user, body)
    end

    # Humidity Notifications
    def user_humidity_notifications(user, cooler)
      user_sms_humidity_notifications(user, cooler) if user.sms_notification
      user_email_humidity_notifications(user, cooler) if user.email_notification
    end

    def user_email_humidity_notifications(user, cooler)
      if cooler.high_humidity?
        user.notify_events.email.create! message: "#{cooler} humidity is very high", sent_at: Time.current
      elsif cooler.low_humidity?
        user.notify_events.email.create! message: "#{cooler} humidity is very low", sent_at: Time.current
      end
      ApplicationMailer.cooler_humidity_notifications(user, cooler).deliver_now
    end

    def user_sms_humidity_notifications(user, cooler)
      if cooler.high_humidity?
        user.notify_events.sms.create! message: "#{cooler} humidity is very high", sent_at: Time.current
      elsif cooler.low_humidity?
        user.notify_events.sms.create! message: "#{cooler} humidity is very low", sent_at: Time.current
      end
      body = "#{cooler.unit} - #{cooler} #{cooler.sensor.humidity}RH(%) has been more than #{cooler.unit.humidity_notify_threshold}% out of range (#{cooler.bottom_humidity_threshold}% - #{cooler.top_humidity_threshold}%) for #{distance_of_time_in_words(cooler.humidity_time_out_of_notify_range)}."
      send_sms(user, body)
    end

    def send_sms(user, body)
      client = Twilio::REST::Client.new
      client.account.messages.create(
        from: Figaro.env.twilio_number,
        to: user.phone_e164,
        body: body
      )
    end
  end
end
