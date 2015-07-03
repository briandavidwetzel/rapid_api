require File.expand_path '../../test_helper.rb', __FILE__

module ActionController

  class PermittedParamsTest < ActionController::TestCase

    class BricksController < ActionController::Base
      include RestfulApi::ActionController::PermittedParams

      permit_params :color,
                    :weight

    end

    tests BricksController

    def test_permits_params
      assert :weight.in?(@controller.permitted_params), ":weight not added to permitted params."
      assert :color.in?(@controller.permitted_params), ":color not added to permitted params."
    end

  end

end
