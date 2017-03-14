module JSONAPI
  module Authorization
    class VSOperationsProcessor < AuthorizingProcessor
      def authorize_create_resource
        authorizer.create_resource(source_class.new(model_args))
      end

      private

      def source_class
        @operation.resource_klass._model_class
      end

      def model_args
        attributes.merge(to_one).merge(to_many)
      end

      def attributes
        @operation.data[:attributes]
      end

      def to_one
        find_values(@operation.data[:to_one])
      end

      def to_many
        find_values(@operation.data[:to_many])
      end

      def find_values(hash)
        hash.map { |k, v| [k, model_class_for_relationship(k).find(v)] }.to_h
      end
    end
  end
end
