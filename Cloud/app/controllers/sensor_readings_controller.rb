class SensorReadingsController < ApplicationController
  include TempsHelper

  def index
    authorize SensorReading
    @sensor = Sensor.find(params[:sensor_id])
    @range = Time.current.all_range(params[:range])
    @metric = params[:metric]
    @readings = @sensor.readings.in(@range)

    respond_to do |format|
      format.json do
        series = Chart.new(@readings, :reading_time, @metric).series
        labels = series.map(&:first)
        data = series.map(&:second)
        data.map! { |datum| temp_converter.convert(datum.second) } if @metric.to_sym == :temp
        render json: { type: 'time', label: "#{@metric.capitalize} (#{units})", labels: labels, data: data, limits: sensor_limits }
      end
      format.xlsx do
        start_time = @range.first.strftime '%D'
        end_time = @range.last.strftime '%D'
        range = start_time == end_time ? start_time : "#{start_time} - #{end_time}"
        name = "#{@sensor} #{range}"
        render xlsx: 'sensor_readings/index', filename: name
      end
    end
  end

  private

  def units
    case @metric.to_sym
    when :temp then temp_units
    when :battery then 'dV'
    when :humidity then 'RH %'
    end
  end

  def sensor_limits
    return unless @metric.to_sym == :temp && @sensor.location.is_a?(Cooler)
    [{ color: '#e94959', value: temp_converter.convert(@sensor.location.top_temp_threshold) },
     { color: '#77C699', value: temp_converter.convert(@sensor.location.bottom_temp_threshold) }]
  end
end
