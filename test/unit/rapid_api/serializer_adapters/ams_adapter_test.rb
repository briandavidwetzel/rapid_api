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
        assert_equal "{\"data\":{\"id\":\"#{brick.id}\",\"type\":\"bricks\",\"attributes\":{\"color\":\"yellow\",\"weight\":\"10.0\",\"material\":\"gold\"}}}", serialized_brick
      end

      def test_serialize_collection
        Brick.destroy_all
        brick1 = Brick.create color: 'yellow', weight: 10, material: 'gold'
        brick2 = Brick.create color: 'red',    weight: 1,  material: 'clay'
        serialized_brick_array = @adapter.serialize_collection Brick.all
        assert_equal "{\"data\":[{\"id\":\"#{brick1.id}\",\"type\":\"bricks\",\"attributes\":{\"color\":\"yellow\",\"weight\":\"10.0\",\"material\":\"gold\"}},{\"id\":\"#{brick2.id}\",\"type\":\"bricks\",\"attributes\":{\"color\":\"red\",\"weight\":\"1.0\",\"material\":\"clay\"}}]}", serialized_brick_array
      end

      def test_serialize_errors
        brick1 = Brick.create color: 'teal', weight: 10, material: 'gold'
        brick1.errors.add(:color,'Invalid color.')
        serialized_errors = @adapter.serialize_errors RapidApi::ModelAdapters::QueryResult.new(errors: brick1.errors)
        assert_equal "{\"errors\":[{\"source\":{\"pointer\":\"/data/attributes/color\"},\"detail\":\"Invalid color.\"}]}", serialized_errors
      end

      def test_deserialize_attributes
        params = ::ActionController::Parameters.new({
                   data: {
                     attributes: { color: 'red', weight: '10.0' },
                     id: 10,
                     type: 'bricks'
                   }
                 })
        assert_equal({ color: 'red', weight: '10.0' }.to_json, @adapter.deserialize_attributes(params, '').to_json)
      end

      def test_deserialize_id
        params = ::ActionController::Parameters.new({
                   data: {
                     attributes: { color: 'red', weight: '10.0' },
                     id: 10,
                     type: 'bricks'
                   }
                 })
        assert_equal(10 , @adapter.deserialize_id(params, ''))
      end

    end
  end
end
