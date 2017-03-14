require 'jsonapi/authorization/vs_operations_processor'
require 'jsonapi/authorization/vs_pundit_authorizer'

JSONAPI.configure do |config|
  config.exception_class_whitelist = [Pundit::NotAuthorizedError]
  config.default_processor_klass = JSONAPI::Authorization::VSOperationsProcessor

  config.default_paginator = :paged
  config.default_page_size = 10
  config.maximum_page_size = 50
end

JSONAPI::Authorization.configure do |config|
  config.authorizer = JSONAPI::Authorization::VSPunditAuthorizer
end
