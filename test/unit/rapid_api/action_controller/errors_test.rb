require File.expand_path '../../../../test_helper.rb', __FILE__

class ActionControllerErrorsTest < ActionController::TestCase

  class TestErroneousController < ActionController::Base
    include RapidApi::ActionController::Errors

    def unauthenticated_action
      not_authenticated!
    end

    def server_error_action
      raise "server error"
    end

  end

  tests TestErroneousController

  def test_unauthenticated_action
    get :unauthenticated_action
    assert_response :unauthorized
    assert_equal ['Not Authenticated'], JSON.parse(@controller.response.body)['errors']
  end

  def test_server_error
    get :server_error_action
    assert_response :internal_server_error
    assert_equal ['Server Error'], JSON.parse(@controller.response.body)['errors']
  end
end
