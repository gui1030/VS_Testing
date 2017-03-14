module Api
  module V6
    module HubCompat
      extend ActiveSupport::Concern

      included do
        delegate :mac, :mac=, to: :sensor
      end
    end
  end
end
