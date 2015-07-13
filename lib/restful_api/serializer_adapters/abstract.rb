module RestfulApi
  module SerializerAdapters
    class Abstract

      attr_accessor :model

      def initialize(model)
        @model = model
      end

      def serialize(member)
        raise NotImplementedError
      end

      def serialize_collection(collection)
        raise NotImplementedError
      end

    end
  end
end
