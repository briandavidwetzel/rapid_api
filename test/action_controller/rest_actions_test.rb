require File.expand_path '../../test_helper.rb', __FILE__

module ActionController

  class RestActionsTest < ActionController::TestCase

    class BricksController < ActionController::Base
      include RestfulApi::ActionController::RestActions

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
      assert_equal 'brick', BricksController.params_key
      BricksController.params_key = 'foo'
      assert_equal 'foo', BricksController.params_key
      BricksController.params_key = 'brick'
    end

    def test_model_adapter
      assert_equal TestModelAdapter, BricksController.model_adapter
    end

    def test_serializer_adapter
      BricksController.serializer_adapter = TestSerializerAdapter
      assert_equal TestSerializerAdapter, BricksController.serializer_adapter
    end

    def test_index
      BricksController.adapted_model = Minitest::Mock.new
      BricksController.adapted_model.expect :find_all, nil, []
      get :index
      assert_response :found
      BricksController.adapted_model.verify
    end

    def test_show
      BricksController.adapted_model = Minitest::Mock.new
      BricksController.adapted_model.expect :find, nil, ["1"]
      BricksController.serializer_adapter = Minitest::Mock.new
      BricksController.serializer_adapter.expect :serialize, nil, [nil]
      get :show, {id: 1}
      assert_response :found
      BricksController.adapted_model.verify
      BricksController.serializer_adapter.verify
    end

    def test_create
      params = {'color' => 'red', 'weight' => '10', 'material' => 'clay'}
      BricksController.adapted_model = Minitest::Mock.new
      BricksController.adapted_model.expect :create, nil, [params]
      BricksController.serializer_adapter = Minitest::Mock.new
      BricksController.serializer_adapter.expect :serialize, nil, [nil]
      post :create, {brick: params}
      assert_response :created
      BricksController.adapted_model.verify
      BricksController.serializer_adapter.verify
    end

    def test_update
      params = {'color' => 'red', 'weight' => '10', 'material' => 'clay'}
      BricksController.adapted_model = Minitest::Mock.new
      BricksController.adapted_model.expect :update, nil, ["1", params]
      BricksController.serializer_adapter = Minitest::Mock.new
      BricksController.serializer_adapter.expect :serialize, nil, [nil]
      post :update, {brick: params, id: 1}
      assert_response :ok
      BricksController.adapted_model.verify
      BricksController.serializer_adapter.verify
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
