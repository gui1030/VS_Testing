require 'test_helper'

class ReportScheduleTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper
  fixtures :all

  test 'daily report' do
    travel_to Time.zone.parse('2015-07-04 06:05:37 EDT')
    assert_reports users(:test) do
      ReportService.send_daily_reports
    end
  end

  test 'weekly report' do
    travel_to Time.zone.parse('2015-07-10 17:00:00')
    assert_reports users(:weekly) do
      ReportService.send_daily_reports
    end
  end

  test 'bi-weekly report' do
    travel_to Time.zone.parse('2015-07-09 12:00:00')
    assert_reports users(:bi_weekly) do
      ReportService.send_daily_reports
      travel 1.week
      ReportService.send_daily_reports
    end
  end

  test 'monthly report' do
    travel_to Time.zone.parse('2015-07-15 08:00:00')
    assert_reports users(:monthly) do
      ReportService.send_daily_reports
    end
  end

  test 'end of month report' do
    travel_to Time.zone.parse('2015-07-28 09:00:00')
    assert_reports users(:month_end), 0 do
      ReportService.send_daily_reports
      travel 1.day
      ReportService.send_daily_reports
      travel 1.day
      ReportService.send_daily_reports
    end

    assert_reports users(:month_end) do
      travel 1.day
      ReportService.send_daily_reports
    end
  end

  private

  def assert_reports(user, count = 1)
    assert_emails count do
      assert_difference -> { user.notify_events.email.count }, count do
        yield
      end
    end
  end
end
