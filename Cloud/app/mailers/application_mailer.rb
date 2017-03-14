class ApplicationMailer < ActionMailer::Base
  default from: '"VeriSolutions" <support@verisolutions.co>'
  layout 'mail'
  add_template_helper MailHelper

  def cooler_notifications(user, cooler)
    @user = user
    @token = TokenService.new_token_for(user)
    @cooler = cooler
    @unit = cooler.unit
    subject = cooler.cold? ? 'Cooler is too cold' : 'Cooler is too hot'
    mail(to: @user.email,
         subject: subject)
  end

  def cooler_humidity_notifications(user, cooler)
    @user = user
    @token = TokenService.new_token_for(user)
    @cooler = cooler
    @unit = cooler.unit
    subject = cooler.high_humidity? ? 'Cooler humidity is very high' : 'Cooler humidity is very low'
    mail(to: @user.email,
         subject: subject)
  end

  def daily_report(user, report_time)
    report_time = report_time.in_time_zone(user.time_zone)
    @user = user
    @token = TokenService.new_token_for(user)
    @range = user.report_start_time(report_time)..report_time

    mail(to: @user.email,
         subject: 'VeriSolutions Compliance Report')
  end
end
