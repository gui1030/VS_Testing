module Api
  module Sf1
    module UnitCompat
      extend ActiveSupport::Concern

      included do
        attr_accessor :create_coolers_count, :create_sensors_count

        after_initialize :build_coolers, if: :create_coolers_count
        after_initialize :build_sensors, if: :create_sensors_count

        def build_coolers
          coolers.build((1..create_coolers_count).map { |i| { name: "Cooler #{i}" } })
        end

        def build_sensors
          sensors.build((1..create_sensors_count).map { |i| { name: "Repeater #{i}" } })
        end
      end
    end
  end
end
