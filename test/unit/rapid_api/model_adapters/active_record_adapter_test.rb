require File.expand_path '../../../../test_helper.rb', __FILE__

module RapidApi
  module ModelAdapters
    class ActiveRecordAdapterTest < Minitest::Test

      def setup
        DatabaseCleaner.start
        @adapter = RapidApi::ModelAdapters::ActiveRecordAdapter.new(Brick)
      end

      def teardown
        DatabaseCleaner.clean
      end

      def test_adapted_klass
        assert_equal Brick, @adapter.klass
      end

      def test_find
        brick = Brick.create color: 'red'
        query_result = @adapter.find(brick.id)
        assert_equal query_result.data, brick
      end

      def test_find_all
        bricks = Brick.all
        query_result = @adapter.find_all
        assert_equal query_result.data, bricks
      end

      def test_create
        params = {color: 'red', weight: 1, material: 'clay'}
        query_result = @adapter.create params
        assert_equal 'red',  query_result.data.color
        assert_equal 1,      query_result.data.weight
        assert_equal 'clay', query_result.data.material
        refute_equal nil,    query_result.data.id
      end

      def test_update
        params        = {color: 'red',    weight: 1,  material: 'clay'}
        update_params = {color: 'yellow', weight: 10, material: 'gold'}
        brick         = Brick.create params
        query_result = @adapter.update(brick.id, update_params)
        assert_equal 'yellow', query_result.data.color
        assert_equal 10,       query_result.data.weight
        assert_equal 'gold',   query_result.data.material
        assert_equal brick.id, query_result.data.id
      end

      def test_destroy
        params = {color: 'red',    weight: 1,  material: 'clay'}
        brick  = Brick.create params
        @adapter.destroy brick.id
        assert Brick.where(id: brick.id).empty?
      end
    end
  end
end
