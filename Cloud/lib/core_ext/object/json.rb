require 'jsonapi/to_api_json'

[Enumerable, Object, Array, FalseClass, Float, Hash, Integer, NilClass, String, TrueClass].each do |klass|
  klass.prepend JSONAPI::ToAPIJSON
end
