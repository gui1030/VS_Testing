module Api
  module Mv2
    class UnitUserResource < UserResource
      has_one :unit
    end
  end
end
