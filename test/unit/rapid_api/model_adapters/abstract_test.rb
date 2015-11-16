require File.expand_path '../../../../test_helper.rb', __FILE__

module RapidApi
  module ModelAdapters
    class AbstractModelAdapterTest < Minitest::Test
      def setup
        @adapter = RapidApi::ModelAdapters::Abstract.new(nil)
      end

      def teardown

      end

      def test_find
        assert_raises NotImplementedError do
          @adapter.find(nil, nil)
        end
      end

      def test_find_all
        assert_raises NotImplementedError do
          @adapter.find_all(nil, nil)
        end
      end

      def test_create
        assert_raises NotImplementedError do
          @adapter.create(nil, nil)
        end
      end

      def test_update
        assert_raises NotImplementedError do
          @adapter.update(nil, nil)
        end
      end

      def test_destroy
        assert_raises NotImplementedError do
          @adapter.destroy(nil, nil)
        end
      end
    end
  end
end
