require File.expand_path '../../../test_helper.rb', __FILE__

module RestfulApi
  module ModelAdapters
    class ActiveRecordAdapterTest < Minitest::Test

      def setup
        @adapter = RestfulApi::ModelAdapters::ActiveRecordAdapter.new(Brick)
      end

      def test_adapted_klass
        assert_equal Brick, @adapter.klass
      end
    end
  end
end
