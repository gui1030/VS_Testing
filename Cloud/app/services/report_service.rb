class ReportService
  class << self
    def send_daily_report(user, report_time)
      user.notify_events.email.create! message: 'Report Sent', sent_at: Time.current
      user.update! last_report_sent_at: Time.current
      ApplicationMailer.daily_report(user, report_time).deliver_now if user.is_a?(UnitUser)
    end

    def send_daily_reports
      report_time = (Time.current + 30.minutes).beginning_of_hour
      User.where(daily_notification: true). each do |u|
        ReportService.send_daily_report(u, report_time) if u.report? report_time
      end
    end
  end
end
