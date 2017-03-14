module Api
  module Mv2
    class CoolersController < BaseController
      include Pundit

      def chart
        @cooler = Cooler.find(params[:id])
        authorize @cooler, :show?

        @range = Time.current.all_range(params[:range])
        @metric = params[:metric]
        @readings = @cooler.sensor.readings.in(@range)

        series = Chart.new(@readings, :reading_time, @metric).series
        series.map! { |datum| [datum.first, temp_converter.convert(datum.second)] } if @metric.to_sym == :temp
        render json: { data: series, format: 'time' }
      end

      private

      def temp_converter
        @temp_converter ||= ConversionService.new(current_user.default_units)
      end
    end
  end
end
