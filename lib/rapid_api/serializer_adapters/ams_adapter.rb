module RapidApi
  module SerializerAdapters
    class AmsAdapter < Abstract

      def serialize(member)
        serializer = klass.new(member)
        serializer.to_json
      end

      def serialize_collection(collection)
        array_serializer = ActiveModel::ArraySerializer.new collection, {
                             each_serializer: klass
                           }
        array_serializer.serializable_array.to_json
      end

    end
  end
end
