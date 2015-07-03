require File.expand_path '../../test_helper.rb', __FILE__

module ActionController

  class RestActionsTest < ActionController::TestCase

    class RestActionsTestController < ActionController::Base
      include RestfulApi::ActionController::RestActions
    end

    tests RestActionsTestController

    def test_index_action
      get :index
      assert_equal'{}', response.body
    end
  end

end
