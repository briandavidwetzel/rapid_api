module RapidApi
  module ModelAdapters
    class Abstract

      attr_accessor :klass

      def initialize(klass)
        @klass = klass
      end

      def find(_id, _scope=nil)
        raise NotImplementedError
      end

      def find_all(_params=nil, _scope=nil)
        raise NotImplementedError
      end

      def create(_params, _scope=nil)
        raise NotImplementedError
      end

      def update(_id, _params, _scope=nil)
        raise NotImplementedError
      end

      def destroy(_id, _scope=nil)
        raise NotImplementedError
      end

    end
  end
end
