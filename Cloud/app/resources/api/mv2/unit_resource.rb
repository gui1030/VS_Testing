module Api
  module Mv2
    class UnitResource < BaseResource
      attributes :name, :locale, :logo, :probe_enabled

      has_many :line_check_lists
      has_many :coolers

      def custom_links(options)
        { chart: options[:serializer].link_builder.self_link(self) + '/chart' }
      end
    end
  end
end
