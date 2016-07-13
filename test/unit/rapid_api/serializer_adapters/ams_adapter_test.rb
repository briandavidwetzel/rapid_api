require File.expand_path '../../../../test_helper.rb', __FILE__

module RapidApi
  module SerializerAdapters
    class AmsAdapterTest < Minitest::Test

      def setup
        @adapter = RapidApi::SerializerAdapters::AmsAdapter.new(BrickSerializer, "brick")
      end

      def test_klass
        assert_equal BrickSerializer, @adapter.klass
      end

      def test_serialize
        brick = Brick.create color: 'yellow', weight: 10, material: 'gold'
        serialized_brick = @adapter.serialize brick
        assert_equal "{\"color\":\"yellow\",\"weight\":\"10.0\",\"material\":\"gold\"}", serialized_brick
      end

      def test_serialize_collection
        Brick.destroy_all
        brick1 = Brick.create color: 'yellow', weight: 10, material: 'gold'
        brick2 = Brick.create color: 'red',    weight: 1,  material: 'clay'
        serialized_brick_array = @adapter.serialize_collection Brick.all
        assert_equal "[{\"color\":\"yellow\",\"weight\":\"10.0\",\"material\":\"gold\"},{\"color\":\"red\",\"weight\":\"1.0\",\"material\":\"clay\"}]", serialized_brick_array
      end

    end
  end
end
