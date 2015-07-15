require 'restful_api/version'
require 'active_support/concern'
require 'restful_api/model_adapters'
require 'restful_api/serializer_adapters'
require 'restful_api/action_controller/rest_actions'
require 'restful_api/configuration'

module RestfulApi

  Configuration.instance.tap do |c|
    c.model_adapter      = ModelAdapters::ActiveRecordAdapter
    c.serializer_adapter = SerializerAdapters::AmsAdapter
  end

  def self.config
    Configuration.instance
  end

end
