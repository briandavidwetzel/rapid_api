require File.expand_path '../../test_helper.rb', __FILE__

class ConfigurationTest < Minitest::Test

  DefaultModelAdapter = Class.new(RestfulApi::ModelAdapters::Abstract)
  RestfulApi.config.model_adapter = DefaultModelAdapter

  class BricksController < ActionController::Base
    include RestfulApi::ActionController::RestActions

    permit_params :color
  end

  def test_default_model_adapter
    assert_equal DefaultModelAdapter, BricksController.model_adapter
  end
end
