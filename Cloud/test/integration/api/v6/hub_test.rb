require 'test_helper'

module Api
  module V6
    class HubTest < BaseTest
      include ActionMailer::TestHelper
      include RequestHelper
      fixtures :all

      endpoint :put, '/api/v6/hub', authorization: auth_basic('admin@example.org', 'passw0rd!')
      check_authorized

      test 'with mac data' do
        api_request payload('test_mac')
        assert_response :ok
        assert_attributes sensors(:hub), mac: 'test_mac'
      end

      private

      def payload(mac)
        {
          coreid: hubs(:one).particle_id,
          data: mac
        }
      end
    end
  end
end
