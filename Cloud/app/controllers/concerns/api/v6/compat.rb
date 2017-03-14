module Api
  module V6
    module Compat
      extend ActiveSupport::Concern

      included do
        Hub.include HubCompat
      end
    end
  end
end
