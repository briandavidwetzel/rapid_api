require File.expand_path '../../test_helper.rb', __FILE__

module ActionController

  class RestActionsTest < ActionController::TestCase

    class BricksController < ActionController::Base
      include RestfulApi::ActionController::RestActions

      self.model_adapter = TestModelAdapter

      permit_params :color, :weight, :material
    end

    tests BricksController

    def test_member_class_name
      assert_equal BricksController.member_class_name, "Brick"
    end

    def test_member_model
      assert_equal BricksController.member_model, Brick
    end

    def test_member_params_key
      assert_equal BricksController.member_params_key, 'brick'
    end

    def test_show_record
      BricksController.adapter_model = Minitest::Mock.new
      BricksController.adapter_model.expect :find, nil, ["1"]
      get :show, {id: 1}
      assert_response :found
      BricksController.adapter_model.verify
    end

    def test_creates_record
      params = {'color' => 'red', 'weight' => '10', 'material' => 'clay'}
      BricksController.adapter_model = Minitest::Mock.new
      BricksController.adapter_model.expect :create, nil, [params]
      post :create, {brick: params}
      assert_response :created
      BricksController.adapter_model.verify
    end

    def test_updates_record
      params = {'color' => 'red', 'weight' => '10', 'material' => 'clay'}
      BricksController.adapter_model = Minitest::Mock.new
      BricksController.adapter_model.expect :update, nil, ["1", params]
      post :update, {brick: params, id: 1}
      assert_response :ok
      BricksController.adapter_model.verify
    end

    def test_destroy_record
      BricksController.adapter_model = Minitest::Mock.new
      BricksController.adapter_model.expect :destroy, nil, ["1"]
      post :destroy, {id: 1}
      assert_response :no_content
      BricksController.adapter_model.verify
    end
  end

end
