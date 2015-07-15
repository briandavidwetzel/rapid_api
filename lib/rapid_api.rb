require 'rapid_api/version'
require 'active_support/concern'
require 'rapid_api/model_adapters'
require 'rapid_api/serializer_adapters'
require 'rapid_api/action_controller'
require 'rapid_api/configuration'

module RapidApi

  Configuration.instance.tap do |c|
    c.model_adapter      = ModelAdapters::ActiveRecordAdapter
    c.serializer_adapter = SerializerAdapters::AmsAdapter
  end

  def self.config
    Configuration.instance
  end

end
ActionController::Base.send :include, RapidApi::ActionController::Macros
