require File.expand_path '../../../../../test_helper.rb', __FILE__

class SessionsControllerTest < ActionController::TestCase

  class TestSessionsController < ActionController::Base
    include RapidApi::Auth::Concerns::SessionsController

    authenticates_with :username, :password do |params|
      User.where(username: params[:username], password: params[:password]).first
    end

    responds_with do |authenticated|
      {
        token: 'foo',
        user: {
          id:       authenticated.id,
          username: authenticated.username
        }
      }
    end
  end

  tests TestSessionsController

  def setup
    super
    DatabaseCleaner.start

    @user = User.create username: 'bob_the_builder', password: 'password'
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_authenticate
    params = {'username' => 'bob_the_builder', 'password' => 'password'}
    post :authenticate, params
    body = JSON.parse(@controller.response.body)
    assert_response :ok
    assert_equal body["token"], 'foo'
    assert_equal body["user"]["id"], @user.id
    assert_equal body["user"]["username"], @user.username
  end

  def test_invalid_credentials
    params = {'username' => 'bob_the_builder', 'password' => 'wrong_password'}
    post :authenticate, params
    body = JSON.parse(@controller.response.body)
    assert_response :unauthorized
    assert_equal body["errors"].first, 'Invalid credentials'
  end

end
