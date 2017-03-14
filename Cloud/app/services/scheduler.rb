class Scheduler
  include ApplicationHelper

  def self.send_daily_report
    ReportService.send_daily_reports
  end

  def self.create_line_checks
    LineCheckService.create_line_checks(Time.current)
  end
end
