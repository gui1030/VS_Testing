ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'twilio_helper'
require 'request_helper'

class ActiveSupport::TestCase
  def assert_attributes(obj, attrs, msg = nil)
    success = attrs.all? do |key, val|
      match = obj.send(key) == val
      unless match
        msg = message(msg) do
          "Expected #{mu_pp(obj)}.#{key} to be #{mu_pp(val)}"
        end
      end
      match
    end
    assert success, msg
  end
end

module ActionDispatch::Integration::RequestHelpers
  def json_http_request(request_method, path, parameters = nil, headers_or_env = nil)
    headers_or_env ||= {}
    headers_or_env['Content-Type'] = Mime::JSON.to_s
    headers_or_env['Accept'] ||= [Mime::JSON.to_s]
    process(request_method, path, parameters, headers_or_env)
  end

  alias jhr json_http_request

  def json
    JSON.parse(body)
  end
end

module Api
  module V6
    class BaseTest < ActionDispatch::IntegrationTest
      include Compat
    end
  end
end
