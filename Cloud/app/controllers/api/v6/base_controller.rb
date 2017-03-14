module Api
  module V6
    class BaseController < ActionController::Base
      include Compat
      respond_to :json
      # Prevent CSRF attacks by raising an exception.
      # For APIs, you may want to use :null_session instead.
      protect_from_forgery with: :null_session
      skip_before_action :verify_authenticity_token

      before_action :authenticate_user
      before_action :set_hub
      before_action :destroy_session

      private

      def authenticate_user
        authenticate_or_request_with_http_basic do |username, password|
          user = Admin.find_by email: username
          sign_in user if user && user.valid_password?(password)
        end
      end

      def set_hub
        @hub = Hub.find_by particle_id: params[:coreid]
        if @hub
          @hub.sensor.update(last_online: Time.current)
        else
          head :not_found
        end
      end

      def destroy_session
        request.session_options[:skip] = true
      end
    end
  end
end
