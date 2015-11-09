module RapidApi
  module ActionController

    module Errors
      extend ActiveSupport::Concern

      NotAuthenticatedError = Class.new StandardError

      included do
        rescue_from StandardError,         with: :_server_error
        rescue_from NotAuthenticatedError, with: :_not_authenticated
      end

      def not_authenticated!
        raise NotAuthenticatedError
      end

      def render_error_message(message, status)
        render json: { errors: [message] }, status: status
      end

      protected

      def _not_authenticated
        render_error_message 'Not Authenticated', :unauthorized
      end

      def _server_error
        render_error_message 'Server Error', :internal_server_error
      end

      module ClassMethods

      end
    end

  end
end
