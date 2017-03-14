module Api
  module Mv2
    class UserResource < BaseResource
      attributes :email,
                 :firstname,
                 :lastname,
                 :email_notification,
                 :sms_notification,
                 :daily_notification,
                 :phone,
                 :probe_enabled,
                 :time_zone

      def self.find_by_key(key, options = {})
        if key.nil?
          context = options[:context]
          model = context[:user]
          resource_for_model(model).new(model, context)
        else
          super
        end
      end
    end
  end
end
