module RapidApi
  module Auth
    module Concerns

      module SessionsController
        extend ActiveSupport::Concern
        include JWTHelpers

        included do
          skip_before_action :authenticate!
        end

        def authenticate
          authenticated = self.class.auth_proc.call(permitted_auth_params)
          if authenticated.present?
            render json:   self.class.responds_with_proc.call(authenticated),
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
            self.auth_proc = Proc.new { |params| block.call(params) }
            [*params].each { |p| self.auth_params << p }
          end

          def responds_with(&block)
            self.responds_with_proc = Proc.new { |authenticated| block.call(authenticated) }
          end
        end
      end

    end
  end
end
