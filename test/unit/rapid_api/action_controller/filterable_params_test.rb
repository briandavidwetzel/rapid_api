require File.expand_path '../../../../test_helper.rb', __FILE__

module ActionController

  class FilterableParamsTest < ActionController::TestCase

    class TestFilterableParamsController < ActionController::Base
      include RapidApi::ActionController::FilterableParams

      filterable_params :color

      def filterable_bricks
        render json: filterable_params, status: :ok
      end
    end

    tests TestFilterableParamsController

    def test_permitted_filterable_params
      assert :color.in?(@controller.class.permitted_filterable_params), "Attribute not added to filterable params."
    end

    def test_filterable_params
      post :filterable_bricks, { color: 'blue', material: 'steel' }
      body = JSON.parse(@controller.response.body)
      expected = { 'color' => 'blue' }
      assert_equal expected, body
    end

  end

end
