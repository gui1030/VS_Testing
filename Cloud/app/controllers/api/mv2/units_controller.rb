module Api
  module Mv2
    class UnitsController < BaseController
      include Pundit

      def chart
        @unit = Unit.find(params[:id])
        authorize @unit, :show?
        range = Time.current.all_range(params[:range])
        readings = @unit.readings.where(reading_time: range)
        groups = case params[:range].to_sym
                 when :day then readings.group_by_hour(:reading_time, format: '%-l%p')
                 when :week, :month then readings.group_by_day(:reading_time, format: '%a %-m-%-e')
                 when :year then readings.group_by_month(:reading_time, format: '%-b')
                 end
        compliance = groups.average(:success).transform_values { |v| v.to_f * 100 }
        render json: { data: compliance.to_a }
      end
    end
  end
end
