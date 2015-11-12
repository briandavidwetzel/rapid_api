require File.expand_path '../../../../test_helper.rb', __FILE__

class ActionControllerErrorsTest < ActionController::TestCase

  class TestErroneousController < ActionController::Base
    include RapidApi::ActionController::Errors

    def unauthenticated_action
      not_authenticated!
    end

    def not_found_action
      not_found!
    end

    def not_processable_action
      brick = Brick.create
      brick.errors.add(:base, 'Sample Error')
      not_processable!(brick.errors)
    end

    def server_error_action
      raise "server error"
    end

  end

  tests TestErroneousController

  def test_unauthenticated_error
    get :unauthenticated_action
    assert_response :unauthorized
    assert_equal ['Not Authenticated'], JSON.parse(@controller.response.body)['errors']
  end

  def test_server_error
    get :server_error_action
    assert_response :internal_server_error
    assert_equal ['Server Error'], JSON.parse(@controller.response.body)['errors']
  end

  def test_not_found_error
    get :not_found_action
    assert_response :not_found
    assert_equal ['Not Found'], JSON.parse(@controller.response.body)['errors']
  end

  def test_not_processable_error
    get :not_processable_action
    assert_response :unprocessable_entity
    assert_equal ['Sample Error'], JSON.parse(@controller.response.body)['errors']['base']
  end
end
