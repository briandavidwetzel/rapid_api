require File.expand_path '../../../../test_helper.rb', __FILE__

module RapidApi
  module SerializerAdapters
    class AbstractAdapterTest < Minitest::Test
      def setup
        @adapter = RapidApi::SerializerAdapters::Abstract.new(nil, nil)
      end

      def teardown

      end

      def test_serialize
        assert_raises NotImplementedError do
          @adapter.serialize(nil)
        end
      end

      def test_serialize_collection
        assert_raises NotImplementedError do
          @adapter.serialize_collection(nil)
        end
      end
    end
  end
end
