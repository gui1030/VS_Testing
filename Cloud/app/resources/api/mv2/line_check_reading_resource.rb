module Api
  module Mv2
    class LineCheckReadingResource < BaseResource
      attributes :temp, :success
      has_one :line_check_item

      after_save :check_completed, if: :temp

      def creatable_attributes
        [:temp]
      end

      def updatable_attributes
        [:temp]
      end

      private

      def check_completed
        if @model.line_check.line_check_readings.all?(&:temp)
          @model.line_check.update(
            completed_at: Time.current,
            completed_by: context[:user]
          )
        end
      end
    end
  end
end
