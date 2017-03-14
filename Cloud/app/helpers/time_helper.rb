require 'time'

module TimeHelper
  def unix_to_date(unix)
    Time.at(unix).in_time_zone(current_user.time_zone).strftime('%-m-%-d-%Y')
  end

  def unix_to_datetime(unix)
    Time.at(unix).in_time_zone(current_user.time_zone).strftime('%-m-%-d-%Y %H:%M')
  end

  def current_time(range)
    case range
    when :day then Time.current.strftime('%B %e, %Y')
    when :week then 'This Week'
    when :month then Time.current.strftime('%B %Y')
    when :year then Time.current.strftime('%Y')
    end
  end
end
