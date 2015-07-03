require 'bundler/setup'
require 'rails'
require 'action_controller'
require 'action_controller/test_case'
require 'restful_api'
require 'minitest/autorun'

module TestHelper
  Routes = ActionDispatch::Routing::RouteSet.new
  Routes.draw do
    get ':controller(/:action(/:id))'
    get ':controller(/:action)'
  end

  ActionController::Base.send :include, Routes.url_helpers
end

ActionController::TestCase.class_eval do
  def setup
    @routes = TestHelper::Routes
  end
end
