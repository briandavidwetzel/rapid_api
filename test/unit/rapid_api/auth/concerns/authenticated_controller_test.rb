require File.expand_path '../../../../../test_helper.rb', __FILE__

class AuthenticatedControllerTest < ActionController::TestCase
  class AuthenticatedTestController < ActionController::Base
    rapid_actions model: Brick, serializer: BrickSerializer

    permit_params :color, :weight, :material
  end

  tests AuthenticatedTestController

  def setup
    super
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

end
