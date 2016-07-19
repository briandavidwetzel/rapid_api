require 'jwt'

module RapidApi
  module Auth
    module Support

      class JWT

        def self.encode(payload={}, ttl_in_sec=nil)
          if ttl_in_sec.present?
            payload[:exp] = Time.current.to_i + ttl_in_sec
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
