module JSONAPI
  module Authorization
    class VSPunditAuthorizer < DefaultPunditAuthorizer
      def create_resource(source_record)
        ::Pundit.authorize(user, source_record, :create?)
      end
    end
  end
end
