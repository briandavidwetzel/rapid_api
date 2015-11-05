module RapidApi
  module Auth
    module Concerns

      module SessionsController
        extend ActiveSupport::Concern

        included do

        end

        def authenticate
          authenticated = self.class.auth_proc.call(permitted_auth_params)
          if authenticated.present?
            render json:   self.class.auth_payload_proc.call(authenticated),
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
          attr_accessor :auth_params, :auth_proc, :auth_payload_proc

          def auth_params
            @auth_params ||= []
          end

          def authenticates_with(*params, &block)
            self.auth_proc = Proc.new { |params| block.call(params) }
            params.each { |p| self.auth_params << p }
          end

          def auth_payload(&block)
            self.auth_payload_proc = Proc.new { |authenticated| block.call(authenticated) }
          end
        end
      end

    end
  end
end
