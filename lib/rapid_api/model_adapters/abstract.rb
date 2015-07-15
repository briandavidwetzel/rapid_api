module RapidApi
  module ModelAdapters
    class Abstract

      attr_accessor :klass

      def initialize(klass)
        @klass = klass
      end

      def find(id)
        raise NotImplementedError
      end

      def find_all(params=nil)
        raise NotImplementedError
      end

      def create(params)
        raise NotImplementedError
      end

      def update(id, params)
        raise NotImplementedError
      end

      def destroy(id)
        raise NotImplementedError
      end

    end
  end
end
