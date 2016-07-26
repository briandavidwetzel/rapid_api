module RapidApi
  module Auth
    module Concerns

      module AuthenticatedController
        extend ActiveSupport::Concern
        include JWTHelpers

        included do
          before_action :authorize!

          attr_accessor :authorized
        end

        def authorize!
          self.authorized = _authorize
          not_authorized! if authorized.nil?
        end

        protected

        def decode_jwt_token!(token)
          begin
            jwt_decode(token)
          rescue JWT::ExpiredSignature
            not_authorized!
          rescue JWT::VerificationError, JWT::DecodeError
            not_authorized!
          end
        end

        module ClassMethods

          def authorize(&block)
            define_method :_authorize, &block
          end

        end

      end

    end
  end
end
