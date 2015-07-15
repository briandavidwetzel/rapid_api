module RapidApi
  module ActionController
    module Macros
      extend ActiveSupport::Concern

      module ClassMethods
        def rapid_actions(options={})
          include RapidApi::ActionController::RestActions
          self.model              = options[:model]              if options[:model]
          self.serializer         = options[:serializer]         if options[:serializer]
          self.model_adapter      = options[:model_adapter]      if options[:model_adapter]
          self.serializer_adapter = options[:serializer_adapter] if options[:serializer_adapter]
        end
      end

    end
  end
end
