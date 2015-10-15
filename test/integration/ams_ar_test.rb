require File.expand_path '../../test_helper.rb', __FILE__

class AmsArTest < ActionController::TestCase
    class AmsArIntegrationController < ActionController::Base
      rapid_actions model: Brick, serializer: BrickSerializer

      permit_params :color, :weight, :material
    end

    tests AmsArIntegrationController

    def setup
      super
      DatabaseCleaner.start
    end

    def teardown
      DatabaseCleaner.clean
    end

    def test_index
      Brick.destroy_all
      brick1 = Brick.create color: 'yellow', weight: 10, material: 'gold'
      brick2 = Brick.create color: 'red',    weight: 1,  material: 'clay'
      get :index
      assert_equal "{\"brick\":[{\"color\":\"yellow\",\"weight\":\"10.0\",\"material\":\"gold\"},{\"color\":\"red\",\"weight\":\"1.0\",\"material\":\"clay\"}]}", response.body
    end

    def test_show
      brick = Brick.create color: 'red',    weight: 1,  material: 'clay'
      get :show, {id: brick.id}
      assert_equal "{\"brick\":{\"color\":\"red\",\"weight\":\"1.0\",\"material\":\"clay\"}}", response.body
    end
end
