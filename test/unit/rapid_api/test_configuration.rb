require File.expand_path '../../test_helper.rb', __FILE__

class ConfigurationTest < Minitest::Test

  DefaultModelAdapter = Class.new(RapidApi::ModelAdapters::Abstract)
  RapidApi.config.model_adapter = DefaultModelAdapter

  class BricksController < ActionController::Base
    include RapidApi::ActionController::ResourceActions

    permit_params :color
  end

  def test_default_model_adapter
    assert_equal DefaultModelAdapter, BricksController.model_adapter
  end
end
