module RapidApi
  module SerializerAdapters
    class Abstract

      attr_accessor :klass

      def initialize(klass)
        @klass = klass
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
