require 'bundler/setup'
require 'byebug'
require 'rails'
require 'action_controller'
require 'action_controller/test_case'
require 'rapid_api'
require 'minitest/autorun'

Dir['./test/support/**/*.rb'].each {|f| require f}

module TestHelper
  ActiveModelSerializers.config.adapter = :json_api
  Routes = ActionDispatch::Routing::RouteSet.new
  Routes.draw do
    # TODO: Need to deal with the deprecation of the dynamic segments
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
