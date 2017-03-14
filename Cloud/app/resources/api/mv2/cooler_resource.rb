module Api
  module Mv2
    class CoolerResource < BaseResource
      attributes :name, :bottom_temp_threshold, :top_temp_threshold, :description
      has_many :sensor_readings

      def custom_links(options)
        { chart: options[:serializer].link_builder.self_link(self) + '/chart' }
      end
    end
  end
end
