module RapidApi
  module ModelAdapters
    class Abstract

      attr_accessor :klass

      def initialize(klass)
        @klass = klass
      end

      def find(id, scope=nil)
        raise NotImplementedError
      end

      def find_all(params=nil, scope=nil)
        raise NotImplementedError
      end

      def create(params, scope=nil)
        raise NotImplementedError
      end

      def update(id, params, scope=nil)
        raise NotImplementedError
      end

      def destroy(id, scope=nil)
        raise NotImplementedError
      end

    end
  end
end
