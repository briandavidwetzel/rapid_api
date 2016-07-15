require File.expand_path '../../../../test_helper.rb', __FILE__

module ActionController

  class ResourceActionsTest < ActionController::TestCase

    class BricksController < ActionController::Base
      include RapidApi::ActionController::ResourceActions

      self.model_adapter      = TestModelAdapter
      self.serializer_adapter = TestSerializerAdapter

      permit_params     :color, :weight, :material
      filterable_params :color

      scope_by :color do |controller|
        'blue'
      end
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
      BricksController.model = Brick
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
      query_result = RapidApi::ModelAdapters::QueryResult.new(data: 'data')
      BricksController.adapted_model.expect :find_all, query_result, [{'color' => 'green'}, {color: 'blue'}]
      BricksController.adapted_serializer = Minitest::Mock.new
      BricksController.adapted_serializer.expect :serialize_collection, nil, ['data']
      get :index, params: {color: 'green', material: 'leaves'}
      assert_response :ok
      BricksController.adapted_model.verify
      BricksController.adapted_serializer.verify
    end

    def test_show
      BricksController.adapted_model = Minitest::Mock.new
      query_result = RapidApi::ModelAdapters::QueryResult.new(data: 'data')
      BricksController.adapted_model.expect :find, query_result, ["1", {color: 'blue'}]
      BricksController.adapted_serializer = Minitest::Mock.new
      BricksController.adapted_serializer.expect :serialize, nil, ['data']
      get :show, params: {id: 1}
      assert_response :ok
      BricksController.adapted_model.verify
      BricksController.adapted_serializer.verify
    end

    def test_show_not_found
      BricksController.adapted_model = Minitest::Mock.new
      query_result = RapidApi::ModelAdapters::QueryResult.new()
      BricksController.adapted_model.expect :find, query_result, ["1", {color: 'blue'}]
      get :show, params: {id: 1}
      assert_response :not_found
      BricksController.adapted_model.verify
    end

    def test_create
      params = {'color' => 'red', 'weight' => '10', 'material' => 'clay'}
      BricksController.adapted_model = Minitest::Mock.new
      query_result = RapidApi::ModelAdapters::QueryResult.new(data: 'data')
      BricksController.adapted_model.expect :create, query_result, [params, {color: 'blue'}]
      BricksController.adapted_serializer = Minitest::Mock.new
      BricksController.adapted_serializer.expect :serialize, nil, ['data']
      post :create, params: {brick: params}
      assert_response :created
      BricksController.adapted_model.verify
      BricksController.adapted_serializer.verify
    end

    def test_create_errors
      params = {'color' => 'red', 'weight' => '10', 'material' => 'clay'}
      BricksController.adapted_model = Minitest::Mock.new
      query_result = RapidApi::ModelAdapters::QueryResult.new(data: 'data', errors: 'dummy error')
      BricksController.adapted_model.expect :create, query_result, [params, {color: 'blue'}]
      post :create, params: {brick: params}
      assert_response :unprocessable_entity
      assert_equal 'dummy error', JSON.parse(@controller.response.body)['errors']
    end

    def test_update
      params = {'color' => 'red', 'weight' => '10', 'material' => 'clay'}
      BricksController.adapted_model = Minitest::Mock.new
      query_result = RapidApi::ModelAdapters::QueryResult.new(data: 'data')
      BricksController.adapted_model.expect :update, query_result, ["1", params, {color: 'blue'}]
      BricksController.adapted_serializer = Minitest::Mock.new
      BricksController.adapted_serializer.expect :serialize, nil, ['data']
      post :update, params: {brick: params, id: 1}
      assert_response :ok
      BricksController.adapted_model.verify
      BricksController.adapted_serializer.verify
    end

    def test_update_not_found
      params = {'color' => 'red', 'weight' => '10', 'material' => 'clay'}
      BricksController.adapted_model = Minitest::Mock.new
      query_result = RapidApi::ModelAdapters::QueryResult.new()
      BricksController.adapted_model.expect :update, query_result, ["1", params, {color: 'blue'}]
      post :update, params: {brick: params, id: 1}
      assert_response :not_found
      BricksController.adapted_model.verify
    end

    def test_update_errors
      params = {'color' => 'red', 'weight' => '10', 'material' => 'clay'}
      BricksController.adapted_model = Minitest::Mock.new
      query_result = RapidApi::ModelAdapters::QueryResult.new(data: 'data', errors: 'dummy error')
      BricksController.adapted_model.expect :update, query_result, ["1", params, {color: 'blue'}]
      post :update, params: {brick: params, id: 1}
      assert_response :unprocessable_entity
      BricksController.adapted_model.verify
    end

    def test_destroy
      BricksController.adapted_model = Minitest::Mock.new
      query_result = RapidApi::ModelAdapters::QueryResult.new()
      BricksController.adapted_model.expect :destroy, query_result, ["1", {color: 'blue'}]
      post :destroy, params: {id: 1}
      assert_response :no_content
      BricksController.adapted_model.verify
    end

    def test_destroy_errors
      BricksController.adapted_model = Minitest::Mock.new
      query_result = RapidApi::ModelAdapters::QueryResult.new(errors: 'dummy error')
      BricksController.adapted_model.expect :destroy, query_result, ["1", {color: 'blue'}]
      post :destroy, params: {id: 1}
      assert_response :unprocessable_entity
      BricksController.adapted_model.verify
    end
  end

end
