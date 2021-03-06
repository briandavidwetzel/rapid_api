module RapidApi
  module Auth
    module Concerns

      module SessionsController
        extend ActiveSupport::Concern
        include JWTHelpers

        included do
          skip_before_action :authorize!, only: [:authenticate]
        end

        def authenticate
          authenticated = _authenticate(permitted_auth_params)
          if authenticated.present?
            render json:   _authentication_response_json(authenticated),
                   status: :ok
          else
            render json: { errors: ['Invalid credentials'] }, status: :unauthorized
          end
        end

        protected

        def permitted_auth_params
          params.permit(*self.class.auth_params)
        end

        module ClassMethods
          attr_accessor :auth_params, :auth_proc, :responds_with_proc

          def auth_params
            @auth_params ||= []
          end

          def authenticates_with(*params, &block)
            define_method :_authenticate, &block
            [*params].each { |p| self.auth_params << p }
          end

          def responds_with(&block)
            define_method :_authentication_response_json, &block
          end
        end
      end

    end
  end
end
