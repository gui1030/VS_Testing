class ApplicationMailerPreview < ActionMailer::Preview
  def cooler_notifications
    unit = Unit.first
    user = unit.users.first
    cooler = unit.coolers.first
    ApplicationMailer.cooler_notifications(user, cooler)
  end

  def daily_report
    unit = Unit.first
    user = unit.users.first
    ApplicationMailer.daily_report(user, Time.current)
  end
end
