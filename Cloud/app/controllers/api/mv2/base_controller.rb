module Api
  module Mv2
    class BaseController < JSONAPI::ResourceController
      force_ssl if: :ssl?
      protect_from_forgery with: :null_session
      before_action :doorkeeper_authorize!
      around_action :use_time_zone

      rescue_from Pundit::NotAuthorizedError, with: :forbidden

      protected

      def current_user
        @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      def context
        { user: current_user }
      end

      private

      def ssl?
        Rails.env.production?
      end

      # https://github.com/cerebris/jsonapi-resources/pull/573
      def handle_exceptions(e)
        if JSONAPI.configuration.exception_class_whitelist.any? { |k| e.class.ancestors.include?(k) }
          raise e
        else
          super
        end
      end

      def forbidden
        head :forbidden
      end

      def use_time_zone(&block)
        Time.use_zone(current_user.time_zone, &block)
      end
    end
  end
end
