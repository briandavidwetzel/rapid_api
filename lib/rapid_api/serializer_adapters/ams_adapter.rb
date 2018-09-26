module RapidApi
  module SerializerAdapters
    class AmsAdapter < Abstract

      def serialize(member)
        serializer = klass.new(member)
        ActiveModelSerializers::Adapter.create(serializer).to_json
      end

      def serialize_collection(collection)
        collection_serializer = ActiveModel::Serializer::CollectionSerializer.new collection, {
                             serializer: klass
                           }
        ActiveModelSerializers::Adapter.create(collection_serializer).to_json
      end

      def serialize_errors(query_result)
        serializer = ActiveModel::Serializer::ErrorSerializer.new(query_result)
        if ActiveModelSerializers.config.adapter == :attributes
          { errors: serializer.as_json }
        else
          ActiveModelSerializers::Adapter.create(serializer).to_json
        end
      end

      def deserialize_attributes(params, root_key)
        #TODO: test attributes deserialization
        if ActiveModelSerializers.config.adapter == :attributes
          params.require(root_key)
        else
          attributes = params
          if params[:data][:attributes].present?
            attributes = params.require(:data).require(:attributes)
          end
          if params[:data][:relationships].present?
            relationships = params.require(:data).require(:relationships)
            relationships.keys.each do |attribute|
             attributes["#{attribute}_id"] = relationships[attribute][:data].try(:[], :id)
            end
          end
          attributes
        end
      end

      def deserialize_id(params, root_key)
        params.require(:id)
      end
    end
  end
end
