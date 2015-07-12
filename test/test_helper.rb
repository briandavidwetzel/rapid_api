require 'bundler/setup'
require 'pry'
require 'rails'
require 'action_controller'
require 'action_controller/test_case'
require 'restful_api'
require 'minitest/autorun'

Dir['./test/fixtures/**/*.rb'].each {|f| require f}

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

  def teardown
  end
end
