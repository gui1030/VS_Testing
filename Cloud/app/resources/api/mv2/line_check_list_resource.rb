module Api
  module Mv2
    class LineCheckListResource < BaseResource
      attribute :name
      has_many :line_checks
      has_many :line_check_items
    end
  end
end
