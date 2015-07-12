module RestfulApi
  module SerializerAdapters
    class Abstract

      attr_accessor :model

      def initialize(model)
        @model = model
      end

      def serialize
        raise NotImplementedError
      end

    end
  end
end
