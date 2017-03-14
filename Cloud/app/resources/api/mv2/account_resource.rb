module Api
  module Mv2
    class AccountResource < BaseResource
      attributes :name

      has_many :units

      def self.default_sort
        [{ field: 'name', direction: :asc }]
      end
    end
  end
end
