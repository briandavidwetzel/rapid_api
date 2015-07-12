module ResfulApi
  module ModelAdapters
    class Abstract

      attr_accessor :klass

      def initialize(klass)
        @klass = klass
      end

      def find(id)
        raise NotImplementedError
      end

      def find_all(params)
        raise NotImplementedError
      end

      def create(params)
        raise NotImplementedError
      end

      def update(id, params)
        raise NotImplementedError
      end

      def destroy(params)
        raise NotImplementedError
      end

    end
  end
end
