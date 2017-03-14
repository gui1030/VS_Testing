module Api
  module V6
    class ReadingsController < BaseController
      def create
        @data = params[:data].split(',')
        sensor = Sensor.find_by mac: @data.shift
        ##TEMPORARY BANDAID.  WE ARE GOING TO IGNORE 400 ERRORS FOR NOW
        return head(:ok) unless sensor
        reading = sensor.readings.create(reading_params)

        if reading
          NotificationService.check_notifications(reading)
          NotificationService.check_humidity_notifications(reading)
          head :created
        else
          ##TEMPORARY BANDAID.  WE ARE GOING TO IGNORE 400 ERRORS FOR NOW
          head :ok
        end
      end

      private

      def reading_params
        temp, humidity, battery, rssi, parent_mac = @data
        ActionController::Parameters.new(
          reading_time: params[:published_at],
          temp: temp,
          humidity: humidity,
          battery: battery,
          rssi: rssi,
          parent_mac: parent_mac
        ).permit!
      end
    end
  end
end
