module RapidApi
  module SerializerAdapters
    class AmsAdapter < Abstract

      def serialize(member)
        serializer = klass.new(member)
        ActiveModelSerializers::Adapter.create(serializer).to_json
      end

      def serialize_collection(collection)
        collection_serializer = ActiveModel::Serializer::CollectionSerializer.new collection, {
                             each_serializer: klass
                           }
        ActiveModelSerializers::Adapter.create(collection_serializer).to_json
      end

      def serialize_errors(query_result)
        serializer = ActiveModel::Serializer::ErrorSerializer.new(query_result)
        ActiveModelSerializers::Adapter.create(serializer).to_json
      end

      # NOTE: Need to add support for :attributes serialization
      def deserialize_attributes(params, root_key)
        params.require(:data).require(:attributes)
      end

      def deserialize_id(params, root_key)
        params.require(:id)
      end
    end
  end
end
