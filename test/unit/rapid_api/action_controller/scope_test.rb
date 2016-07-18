require File.expand_path '../../../../test_helper.rb', __FILE__

module ActionController

  class ScopeTest < ActionController::TestCase

    class TestScopesController < ActionController::Base
      include RapidApi::ActionController::Scope

      scope_by :user_id, :org_id do
        [params['user_id'], params['org_id']]
      end

      def scoped_bricks
        render json: scope.to_json, status: :ok
      end
    end

    tests TestScopesController

    def test_scope_by
      get :scoped_bricks, params: { user_id: 1, org_id: 2 }
      body = JSON.parse(@controller.response.body)
      assert_equal '1', body['user_id']
      assert_equal '2', body['org_id']
    end
  end

end
