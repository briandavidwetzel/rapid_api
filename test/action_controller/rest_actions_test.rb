require File.expand_path '../../test_helper.rb', __FILE__

module ActionController

  class RestActionsTest < ActionController::TestCase

    class BricksController < ActionController::Base
      include RestfulApi::ActionController::RestActions
    end

    tests BricksController

    def test_has_index_action
      assert 'index'.in?(@controller.action_methods), "Index action is not defined."
    end

    def test_has_show_action
      assert 'show'.in?(@controller.action_methods), "Show action is not defined."
    end

    def test_has_create_action
      assert 'create'.in?(@controller.action_methods), "Create action is not defined."
    end

    def test_has_update_action
      assert 'update'.in?(@controller.action_methods), "Update action is not defined."
    end

    def test_has_destroy_action
      assert 'destroy'.in?(@controller.action_methods), "Destroy action is not defined."
    end

    def test_member_class_name
      assert_equal BricksController.member_class_name, "Brick"
    end

    def test_member_model
      assert_equal BricksController.member_model, Brick
    end

    def test_member_params_key
      assert_equal BricksController.member_params_key, 'brick'
    end

    def test_collection_model
      assert_equal BricksController.collection_model, Brick
    end

  end

end
