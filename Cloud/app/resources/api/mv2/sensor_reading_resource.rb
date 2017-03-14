module Api
  module Mv2
    class SensorReadingResource < BaseResource
      attributes :reading_time, :temp, :humidity, :battery
    end
  end
end
