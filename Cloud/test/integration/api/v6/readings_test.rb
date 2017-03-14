require 'test_helper'

module Api
  module V6
    class ReadingsTest < BaseTest
      include ActionMailer::TestHelper
      include RequestHelper
      fixtures :all

      endpoint :post, '/api/v6/readings', authorization: auth_basic('admin@example.org', 'passw0rd!')
      check_authorized

      setup do
        Twilio::REST::Client.messages.clear
        ActionMailer::Base.deliveries.clear
      end

      test 'with cooler data' do
        api_request payload
        assert_response :created
        assert_equal SensorReading.count, 1
        assert_equal coolers(:one).readings.count, 1

        assert_attributes coolers(:one).readings.last,
                          reading_time: Time.zone.parse('2016-10-19T18:14:54.527Z'),
                          temp: 3,
                          humidity: 34,
                          battery: 3140,
                          rssi: -70,
                          parent_mac: sensors(:hub).mac
      end

      test 'with compliance out of range' do
        api_request payload(temp: 6)
        assert_response :created

        assert_attributes coolers(:one).readings.last, success: false

        assert_equal NotifyEvent.count, 0
        assert_equal Twilio::REST::Client.messages.size, 0
        assert_emails 0
      end

      test 'with compliance way out of range' do
        api_request payload(temp: 11)
        assert_response :created

        assert_attributes coolers(:one).readings.last, success: false

        assert_equal NotifyEvent.count, 2
        assert_equal Twilio::REST::Client.messages.size, 1
        assert_emails 1
      end

      test 'with two way out of range in a row' do
        api_request payload(temp: 11)
        assert_response :created

        assert_equal NotifyEvent.count, 2
        assert_equal Twilio::REST::Client.messages.size, 1
        assert_emails 1

        assert_no_difference [-> { NotifyEvent.count },
                              -> { Twilio::REST::Client.messages.size },
                              -> { ActionMailer::Base.deliveries.size }] do
          api_request payload(temp: 11).merge(published_at: '2016-10-19T18:24:54.527Z')
        end
      end

      test 'with unknown sensor' do
        api_request payload(mac: 'bogus_mac')
        assert_response :not_found

        assert_equal SensorReading.count, 0
      end

      private

      def payload(options = {})
        mac = options[:mac] || sensors(:cooler_one).mac
        temp = options[:temp] || 3
        humidity = options[:humidity] || 34
        battery = options[:battery] || 3140
        rssi = options[:rssi] || -70
        parent_mac = options[:parent_mac] || sensors(:hub).mac
        {
          coreid: hubs(:one).particle_id,
          published_at: '2016-10-19T18:14:54.527Z',
          data: "#{mac},#{temp},#{humidity},#{battery},#{rssi},#{parent_mac}"
        }
      end
    end
  end
end
