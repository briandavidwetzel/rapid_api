module RapidApi
  module Auth
    module Concerns

      module JWTHelpers
        extend ActiveSupport::Concern

        included do

        end

        def jwt_encode(payload)
          Support::JWT.encode(payload)
        end

        def jwt_decode(token)
          Support::JWT.decode(token)
        end

      end

    end
  end
end
