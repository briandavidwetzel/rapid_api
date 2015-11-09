require File.expand_path '../../../../../test_helper.rb', __FILE__

class AuthenticatedControllerTest < ActionController::TestCase

  class TestAuthenticatedController < ActionController::Base
    include RapidApi::ActionController::Errors
    include RapidApi::Auth::Concerns::AuthenticatedController

    rapid_actions model: Brick, serializer: BrickSerializer

    permit_params :color, :weight, :material

    authenticate do |request|
      User.first
    end
  end

  tests TestAuthenticatedController

  def setup
    super
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_authenticated
    @user = User.create
    get :index
    assert_equal @controller.authenticated.id, @user.id
  end

  def test_not_authenticated
    User.delete_all
    get :index
    assert_response :unauthorized
  end

end
