module ReportsHelper
  def report_frequency_in_words(user)
    case user.report_frequency
    when 'daily' then 'the last 24 hours'
    when 'weekly' then 'the last week'
    when 'bi_weekly' then 'the last two weeks'
    when 'monthly' then
      now = Time.current
      days = (now - (now - 1.month)) / 1.day
      "the last #{days.round} days"
    end
  end

  def report_window(range)
    "#{range.first.strftime('%-m/%-d  %I:%M%p')} - #{range.last.strftime('%-m/%-d %I:%M%p')}"
  end
end
