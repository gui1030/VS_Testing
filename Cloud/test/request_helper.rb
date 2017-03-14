module RequestHelper
  def self.included(base)
    base.extend ClassMethods
  end

  def api_request(parameters = nil, headers = {})
    jhr self.class.request_method, self.class.path, ensure_json(parameters), self.class.headers.merge(headers)
  end

  module ClassMethods
    attr_accessor :request_method, :path, :headers

    def endpoint(request_method, path, headers = {})
      self.request_method = request_method
      self.path = path
      self.headers = headers
    end

    def check_authorized
      test 'requires authorization' do
        jhr self.class.request_method, self.class.path
        assert_response 401
      end

      test 'fails on bad auth token' do
        jhr self.class.request_method, self.class.path, nil, authorization: auth_token('bogus')
        assert_response 401
      end
    end

    def auth_token(seed)
      ActionController::HttpAuthentication::Token.encode_credentials(seed)
    end

    def auth_basic(user, pw)
      ActionController::HttpAuthentication::Basic.encode_credentials(user, pw)
    end
  end

  protected

  def auth_token(seed)
    self.class.auth_token(seed)
  end

  def auth_basic(user, pw)
    self.class.auth_basic(user, pw)
  end

  private

  def ensure_json(parameters)
    case parameters
    when String, nil then parameters
    else parameters.to_json
    end
  end
end
