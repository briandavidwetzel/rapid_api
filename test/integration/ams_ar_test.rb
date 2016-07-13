require File.expand_path '../../test_helper.rb', __FILE__

class AmsArTest < ActionController::TestCase
  class AmsArIntegrationController < ActionController::Base
    include RapidApi::ActionController::Errors

    rapid_actions model: Brick, serializer: BrickSerializer

    scope_by :user_id do |controller|
      controller.params['user_id']
    end

    permit_params :color, :weight, :material
  end

  tests AmsArIntegrationController

  def setup
    super
    DatabaseCleaner.start
    Brick.delete_all
    @user1 = User.create
    @user2 = User.create
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_index
    Brick.destroy_all
    brick1 = @user1.bricks.create color: 'yellow',  weight: 10, material: 'gold'
    brick2 = @user1.bricks.create color: 'red',     weight: 1,  material: 'clay'
    brick3 = @user2.bricks.create color: 'magenta', weight: 0,  material: 'feathers'
    get :index, { user_id: @user1.id }
    assert_equal "[{\"color\":\"yellow\",\"weight\":\"10.0\",\"material\":\"gold\"},{\"color\":\"red\",\"weight\":\"1.0\",\"material\":\"clay\"}]", response.body
  end

  def test_show
    brick = Brick.create color: 'red',    weight: 1,  material: 'clay'
    get :show, {id: brick.id}
    assert_equal "{\"color\":\"red\",\"weight\":\"1.0\",\"material\":\"clay\"}", response.body
  end
end
