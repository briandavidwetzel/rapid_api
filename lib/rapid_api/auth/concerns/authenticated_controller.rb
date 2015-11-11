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
          self.extend JWTHelpers
          self.extend AuthenticationHelpers
          self.authenticated = self.class.authenticate_proc.call(self)
          not_authenticated! if authenticated.nil?
        end

        protected

        module ClassMethods
          attr_accessor :authenticate_proc

          def authenticate(&block)
            self.authenticate_proc = Proc.new { |request| block.call(request) }
          end

          def inherited(child)
            child.authenticate_proc = authenticate_proc
          end

        end

        module AuthenticationHelpers

          def decode_jwt_token!(token)
            begin
              jwt_decode(token)
            rescue JWT::ExpiredSignature
              not_authenticated!
            rescue JWT::VerificationError, JWT::DecodeError
              not_authenticated!
            end
          end

        end

      end

    end
  end
end
