module Api
  module Mv2
    class LineCheckItemResource < BaseResource
      attributes :name, :temp_high, :temp_low, :description
    end
  end
end
