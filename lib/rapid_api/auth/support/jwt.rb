require 'jwt'

module RapidApi
  module Auth
    module Support

      class JWT

        def self.encode(payload={}, ttl=3600)
          if ttl.present?
            payload[:exp] = Time.current.to_i + ttl
          end
          encrypt_key = nil; #TODO: Make this configurable
          encrypt_alg = 'none'

          ::JWT.encode payload, encrypt_key, encrypt_alg
        end

        def self.decode(token)
          decrypt_key = nil;
          ::JWT.decode token, decrypt_key, false
        end

      end

    end
  end
end
