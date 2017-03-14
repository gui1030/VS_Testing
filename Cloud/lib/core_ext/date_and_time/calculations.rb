module DateAndTime
  module Calculations
    def all_range(range)
      case range.to_sym
      when :day then all_day
      when :week then all_week
      when :month then all_month
      when :year then all_year
      end
    end

    def beginning_of_range(range)
      case range.to_sym
      when :day then beginning_of_day
      when :week then beginning_of_week
      when :month then beginning_of_month
      when :year then beginning_of_year
      end
    end

    def end_of_range(range)
      case range.to_sym
      when :day then end_of_day
      when :week then end_of_week
      when :month then end_of_month
      when :year then end_of_year
      end
    end
  end
end
