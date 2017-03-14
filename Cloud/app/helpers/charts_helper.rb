module ChartsHelper
  def chart_ranges
    %i(day week month year)
  end

  def chart_metrics
    %i(temp humidity battery)
  end
end
