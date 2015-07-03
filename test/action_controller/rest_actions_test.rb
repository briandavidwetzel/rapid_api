require File.expand_path '../../test_helper.rb', __FILE__

module ActionController

  class RestActionsTest < ActionController::TestCase

    RestActionsTest = Class.new(Model)

    class RestActionsTestController < ActionController::Base
      include RestfulApi::ActionController::RestActions
    end

    tests RestActionsTestController

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
  end

end
