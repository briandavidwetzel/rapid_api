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
        brick = Brick.create color: 'red1'
        query_result = @adapter.find(brick.id)
        assert_equal brick, query_result.data
      end

      def test_find_all
        Brick.delete_all
        brick1 = Brick.create color: 'blue'
        brick2 = Brick.create color: 'green'
        query_result = @adapter.find_all
        assert_equal [brick1.id, brick2.id],  query_result.data.map(&:id)
      end

      def test_create
        params = {color: 'red2', weight: 1, material: 'clay'}
        query_result = @adapter.create params
        assert_equal 'red2', query_result.data.color
        assert_equal 1,      query_result.data.weight
        assert_equal 'clay', query_result.data.material
        refute_equal nil,    query_result.data.id
      end

      def test_create_errors
        params = {color: 'red3', weight: 1, material: 'clay'}
        @adapter.create params
        query_result = @adapter.create params
        assert_equal true, query_result.has_errors?
      end

      def test_update
        params        = {color: 'red4',    weight: 1,  material: 'clay'}
        update_params = {color: 'yellow1', weight: 10, material: 'gold'}
        brick         = Brick.create params
        query_result = @adapter.update(brick.id, update_params)
        assert_equal 'yellow1', query_result.data.color
        assert_equal 10,       query_result.data.weight
        assert_equal 'gold',   query_result.data.material
        assert_equal brick.id, query_result.data.id
      end

      def test_update_errors
        params        = {color: 'red5',    weight: 1,  material: 'clay'}
        update_params = {color: 'yellow2', weight: 10, material: 'gold'}
        brick         = Brick.create params
        Brick.create update_params
        query_result = @adapter.update(brick.id, update_params)
        assert_equal true, query_result.has_errors?
      end

      def test_destroy
        params = {color: 'red6',    weight: 1,  material: 'clay'}
        brick  = Brick.create params
        @adapter.destroy brick.id
        assert Brick.where(id: brick.id).empty?
      end

      def test_destroy_errors
        params = {color: 'prevent_destroy', weight: 1,  material: 'clay'}
        brick  = Brick.create params
        query_result = @adapter.destroy brick.id
        assert_equal true, query_result.has_errors?
      end

      def test_find_with_scope
        brick = Brick.create color: 'magenta'
        query_result = @adapter.find(brick.id, {color: 'orange'})
        assert_nil query_result.data
        query_result = @adapter.find(brick.id, {color: 'magenta'})
        assert_equal brick, query_result.data
      end

      def test_find_all_with_scope
        Brick.delete_all
        brick1 = Brick.create color: 'blue'
        brick2 = Brick.create color: 'green'
        params = {color: 'green'}
        scope  = {color: 'blue'}
        query_result = @adapter.find_all params, scope
        assert_equal [brick1.id],  query_result.data.map(&:id)
      end

      def test_create_with_scope
        params = {color: 'lavender', weight: 1, material: 'clay'}
        query_result = @adapter.create params, {weight: 2, material: 'flowers'}
        assert_equal 'lavender',  query_result.data.color
        assert_equal 2,           query_result.data.weight
        assert_equal 'flowers',   query_result.data.material
        refute_equal nil,         query_result.data.id
      end

      def test_find_all_with_params
        Brick.delete_all
        brick1 = Brick.create color: 'blue'
        brick2 = Brick.create color: 'green'
        params = {color: 'green'}
        query_result = @adapter.find_all params
        assert_equal [brick2.id],  query_result.data.map(&:id)
      end
    end
  end
end
