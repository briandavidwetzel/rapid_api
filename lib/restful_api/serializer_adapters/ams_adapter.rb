module RestfulApi
  module SerializerAdapters
    class AmsAdapter < Abstract

      def serialize(member)
        klass.new(member).to_json
      end

      def serialize_collection(collection)
        ActiveModel::ArraySerializer.new(collection).to_json
      end

    end
  end
end
