require File.expand_path '../../../../../test_helper.rb', __FILE__

class AuthenticatedControllerTest < ActionController::TestCase

  class TestAuthenticatedController < ActionController::Base
    include RapidApi::ActionController::Errors
    include RapidApi::Auth::Concerns::AuthenticatedController

    rapid_actions model: Brick, serializer: BrickSerializer

    permit_params :color, :weight, :material

    authenticate do |controller|
      token = controller.jwt_token
      user_id = token[0].try :[], 'user_id'
      if user_id.present?
        User.find user_id
      else
        nil
      end
    end
  end

  TestChildAuthenticatedController = Class.new TestAuthenticatedController

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
    token = RapidApi::Auth::Support::JWT.encode({ user_id: @user.id })
    @request.env['Authorization'] = token
    get :index
    assert_response :ok
    assert_equal @controller.authenticated.id, @user.id
  end

  def test_not_authenticated_without_user
    User.delete_all
    get :index
    assert_response :unauthorized
  end

  def test_child_controller
    assert_equal TestAuthenticatedController.authenticate_proc, TestChildAuthenticatedController.authenticate_proc
  end

end
