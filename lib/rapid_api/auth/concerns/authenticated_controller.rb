module RapidApi
  module Auth
    module Concerns

      module AuthenticatedController
        extend ActiveSupport::Concern

        included do
          before_filter :authenticate!

          attr_accessor :authenticated
        end

        def authenticate!
          self.authenticated = self.class.authenticate_proc.call(request)
          not_authenticated! if authenticated.nil?
        end

        module ClassMethods
          attr_accessor :authenticate_proc

          def authenticate(&block)
            self.authenticate_proc = Proc.new { |request| block.call(request) }
          end
        end
      end

    end
  end
end
