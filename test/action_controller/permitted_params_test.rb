require File.expand_path '../../test_helper.rb', __FILE__

module ActionController

  class PermittedParamsTest < ActionController::TestCase

    class BricksController < ActionController::Base
      include RestfulApi::ActionController::PermittedParams

      permit_params :color

      def permissive_bricks
        render json: _permitted_member_params(:brick).to_json, status: :ok
      end

    end

    tests BricksController

    def test_permits_params
      assert :color.in?(@controller.permitted_params), "Attribute not added to permitted params."
    end

    def test_permitted_member_params
      post :permissive_bricks, {brick: {color: 'red', weight: 1}}
      refute response.body.include?("\"weight\":\"1.0\""), ":attribute should not have been permitted."
      assert response.body.include?("\"color\":\"red\""), ":attribute should have been permitted."
    end
  end

end
