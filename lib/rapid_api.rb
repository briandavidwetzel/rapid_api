require 'rapid_api/version'
require 'active_support/concern'
require 'rapid_api/model_adapters'
require 'rapid_api/serializer_adapters'
require 'rapid_api/action_controller'
require 'rapid_api/auth'
require 'rapid_api/configuration'

module RapidApi

  Configuration.instance.tap do |c|
    c.model_adapter      = ModelAdapters::ActiveRecordAdapter
    c.serializer_adapter = SerializerAdapters::AmsAdapter
    c.response_codes = {
      :ok                    => :ok,
      :created               => :created,
      :not_found             => :not_found,
      :unprocessable_entity  => :unprocessable_entity,
      :unauthorized          => :unauthorized,
      :internal_server_error => :internal_server_error
    }
  end

  def self.config
    Configuration.instance
  end

end

if defined?(ActionController::Base)
  ActionController::Base.send :include, RapidApi::ActionController::Macros
end

if defined?(ActionController::API)
  ActionController::API.send :include, RapidApi::ActionController::Macros
end

if defined?(ActiveModelSerializers)
  ActiveModelSerializers.config.adapter = :json_api
end
