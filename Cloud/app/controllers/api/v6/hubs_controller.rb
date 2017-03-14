module Api
  module V6
    class HubsController < BaseController
      def update
        @sensor = @hub.sensor
        if @sensor.update(sensor_params)
          head :ok
        else
          render json: { errors: @sensor.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def sensor_params
        ActionController::Parameters.new(
          mac: params[:data]
        ).permit!
      end
    end
  end
end
