module RapidApi
  module Services
    class RapidApi::Services::BaseService

      attr_accessor :params,
                    :response,
                    :bang_mode

      def self.method_missing(meth, *args, &block)
        if meth[-1] == '!'
          meth = meth.to_s.split('!')[0].to_sym
          bang_mode = true
        else
          bang_mode = false
        end
        if instance_methods.include? meth
          service = self.new(*args)
          service.bang_mode = bang_mode
          service.send(meth)
          if bang_mode
            return service.response.value
          else
            return service.response
          end
        else
          super
        end
      end

      def initialize(params={})
        @params   = params
        @response = ServiceResponse.new
        after_initialize
      end

      def after_initialize
      end

      def add_error(key, message)
        raise "#{key}: #{message}" if bang_mode

        error_key = response.errors[key]
        error_key ||= []
        error_key << message
      end

      def return_value(value)
        response.value = value
      end

      protected

      def _transfer_errors_from_active_record(model)
        if model.errors.any?
          model.errors.keys.each do |k|
            response.errors[k]= model.errors[k]
          end
        end
      end

    end
  end
end
