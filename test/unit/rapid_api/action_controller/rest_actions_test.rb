require File.expand_path '../../../../test_helper.rb', __FILE__

module ActionController

  class RestActionsTest < ActionController::TestCase

    class BricksController < ActionController::Base
      include RapidApi::ActionController::RestActions

      self.model_adapter      = TestModelAdapter
      self.serializer_adapter = TestSerializerAdapter

      permit_params :color, :weight, :material
    end

    Foo = Class.new(Brick)

    tests BricksController

    def test_model_class_name
      assert_equal BricksController.model_class_name, "Brick"
    end

    def test_model
      assert_equal Brick, BricksController.model
      BricksController.model = Foo
      assert_equal Foo, BricksController.model
    end

    def test_params_key
      BricksController.model = Brick
      assert_equal 'brick', BricksController.params_key
      BricksController.params_key = 'foo'
      assert_equal 'foo', BricksController.params_key
      BricksController.params_key = 'brick'
    end

    def test_model_adapter
      assert_equal TestModelAdapter, BricksController.model_adapter
    end

    def test_adapted_serializer
      BricksController.serializer_adapter = TestSerializerAdapter
      assert_equal TestSerializerAdapter, BricksController.serializer_adapter
    end

    def test_index
      BricksController.adapted_model = Minitest::Mock.new
      BricksController.adapted_model.expect :find_all, nil, []
      BricksController.adapted_serializer = Minitest::Mock.new
      BricksController.adapted_serializer.expect :serialize_collection, nil, [nil]
      get :index
      assert_response :ok
      BricksController.adapted_model.verify
      BricksController.adapted_serializer.verify
    end

    def test_show
      BricksController.adapted_model = Minitest::Mock.new
      BricksController.adapted_model.expect :find, nil, ["1"]
      BricksController.adapted_serializer = Minitest::Mock.new
      BricksController.adapted_serializer.expect :serialize, nil, [nil]
      get :show, {id: 1}
      assert_response :ok
      BricksController.adapted_model.verify
      BricksController.adapted_serializer.verify
    end

    def test_create
      params = {'color' => 'red', 'weight' => '10', 'material' => 'clay'}
      BricksController.adapted_model = Minitest::Mock.new
      BricksController.adapted_model.expect :create, nil, [params]
      BricksController.adapted_serializer = Minitest::Mock.new
      BricksController.adapted_serializer.expect :serialize, nil, [nil]
      post :create, {brick: params}
      assert_response :created
      BricksController.adapted_model.verify
      BricksController.adapted_serializer.verify
    end

    def test_update
      params = {'color' => 'red', 'weight' => '10', 'material' => 'clay'}
      BricksController.adapted_model = Minitest::Mock.new
      BricksController.adapted_model.expect :update, nil, ["1", params]
      BricksController.adapted_serializer = Minitest::Mock.new
      BricksController.adapted_serializer.expect :serialize, nil, [nil]
      post :update, {brick: params, id: 1}
      assert_response :ok
      BricksController.adapted_model.verify
      BricksController.adapted_serializer.verify
    end

    def test_destroy
      BricksController.adapted_model = Minitest::Mock.new
      BricksController.adapted_model.expect :destroy, nil, ["1"]
      post :destroy, {id: 1}
      assert_response :no_content
      BricksController.adapted_model.verify
    end
  end

end
