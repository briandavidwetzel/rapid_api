module RapidApi
  module Auth
    module Concerns

      module SessionsController
        extend ActiveSupport::Concern

        included do

        end

        def authenticate
          render json: {token: 'foo'}, status: :ok
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

          def auth_params
            @auth_params ||= []
          end

          def authenticates_with(*params)
            params.each { |p| self.auth_params << p }
          end
        end
      end

    end
  end
end
