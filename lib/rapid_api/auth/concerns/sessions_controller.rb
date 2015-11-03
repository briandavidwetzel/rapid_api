module RapidApi
  module Auth
    module Concerns

      module SessionsController
        extend ActiveSupport::Concern

        included do

        end

        def authenticate
          
        end

        protected

        def permitted_auth_params
          params.permit(*self.class.auth_params)
        end

        def auth_model
          RapidApi.config.auth_model
        end

        module ClassMethods
          attr_accessor :auth_params

          def authenticates_with(*params)
            self.auth_params << *params
          end
        end
      end

    end
  end
end
