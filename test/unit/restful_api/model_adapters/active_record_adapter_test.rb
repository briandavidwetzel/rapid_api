require File.expand_path '../../../../test_helper.rb', __FILE__

module RestfulApi
  module ModelAdapters
    class ActiveRecordAdapterTest < Minitest::Test

      def setup
        DatabaseCleaner.start
        @adapter = RestfulApi::ModelAdapters::ActiveRecordAdapter.new(Brick)
      end

      def teardown
        DatabaseCleaner.clean
      end

      def test_adapted_klass
        assert_equal Brick, @adapter.klass
      end

      def test_find
        brick = Brick.create color: 'red'
        assert_equal @adapter.find(brick.id), brick
      end

      def test_find_all
        bricks = Brick.all
        assert_equal @adapter.find_all, bricks
      end

      def test_create
        params = {color: 'red', weight: 1, material: 'clay'}
        brick = @adapter.create params
        assert_equal 'red',  brick.color
        assert_equal 1,      brick.weight
        assert_equal 'clay', brick.material
        refute_equal nil,    brick.id
      end

      def test_update
        params        = {color: 'red',    weight: 1,  material: 'clay'}
        update_params = {color: 'yellow', weight: 10, material: 'gold'}
        brick         = Brick.create params
        updated_brick = @adapter.update(brick.id, update_params)
        assert_equal 'yellow', updated_brick.color
        assert_equal 10,       updated_brick.weight
        assert_equal 'gold',   updated_brick.material
        assert_equal brick.id, updated_brick.id
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
