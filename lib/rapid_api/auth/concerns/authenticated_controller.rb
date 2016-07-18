module RapidApi
  module Auth
    module Concerns

      module AuthenticatedController
        extend ActiveSupport::Concern
        include JWTHelpers

        included do
          before_action :authenticate!

          attr_accessor :authenticated
        end

        def authenticate!
          self.authenticated = _authenticate
          not_authenticated! if authenticated.nil?
        end

        protected

        def decode_jwt_token!(token)
          begin
            jwt_decode(token)
          rescue JWT::ExpiredSignature
            not_authenticated!
          rescue JWT::VerificationError, JWT::DecodeError
            not_authenticated!
          end
        end

        module ClassMethods
          attr_accessor :authenticate_proc

          def authenticate(&block)
            define_method :_authenticate, &block
          end

          def inherited(child)
            child.authenticate_proc = authenticate_proc
          end

        end

      end

    end
  end
end
