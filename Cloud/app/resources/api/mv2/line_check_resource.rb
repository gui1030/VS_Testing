module Api
  module Mv2
    class LineCheckResource < BaseResource
      attributes :completed_at, :status
      has_one :line_check_list
      has_one :created_by
      has_one :completed_by
      has_many :line_check_readings

      before_save do
        @model.created_by = context[:user] if @model.new_record?
      end

      def status
        return 0 if pending?
        return 1 if complete?
        return 2 if missed?
      end

      def createable_fields
        [:line_check_list]
      end

      def updatable_fields
        []
      end

      private

      def pending?
        @model.completed_at.nil? && @model == @model.line_check_list.line_checks.first
      end

      def complete?
        @model.completed_at.present?
      end

      def missed?
        !pending? && !complete?
      end
    end
  end
end
