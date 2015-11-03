require File.expand_path '../../../../../test_helper.rb', __FILE__

class SessionsControllerTest < ActionController::TestCase

  class SessionsTestController < ActionController::Base
    include RapidApi::Auth::Concerns::SessionsController

    authenticates_with :username, :password
  end

  tests SessionsTestController

  def setup
    super
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end


  def test_authenticate
    params = {'username' => 'bob_the_builder', 'password' => 'password'}
    post :authenticate, params
  end

end
