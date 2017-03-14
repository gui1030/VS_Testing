module Api
  module Sf1
    module AccountCompat
      extend ActiveSupport::Concern

      included do
        accepts_nested_attributes_for :users, reject_if: :all_blank
        accepts_nested_attributes_for :units, reject_if: :all_blank
      end
    end
  end
end
