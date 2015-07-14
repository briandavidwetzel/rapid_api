require File.expand_path '../../../test_helper.rb', __FILE__

module RestfulApi
  module SerializerAdapters
    class AmsAdapterTest < Minitest::Test

      def setup
        @adapter = RestfulApi::SerializerAdapters::AmsAdapter.new(BrickSerializer)
      end

      def test_klass
        assert_equal BrickSerializer, @adapter.klass
      end

    end
  end
end
