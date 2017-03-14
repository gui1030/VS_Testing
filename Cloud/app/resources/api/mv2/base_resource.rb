module Api
  module Mv2
    class BaseResource < JSONAPI::Resource
      include JSONAPI::Authorization::PunditScopedResource
      abstract
    end
  end
end
