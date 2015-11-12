module RapidApi
  module ActionController

    module Errors
      extend ActiveSupport::Concern

      NotAuthenticatedError = Class.new StandardError
      NotFoundError         = Class.new StandardError

      included do
        rescue_from StandardError,         with: :_server_error
        rescue_from NotAuthenticatedError, with: :_not_authenticated
        rescue_from NotFoundError,         with: :_not_found
      end

      def not_authenticated!
        raise NotAuthenticatedError
      end

      def not_found!
        raise NotFoundError
      end

      protected

      def render_error_message(message, status, e)
        render json: { errors: [message] }, status: status
      end

      def log_error(e)
        puts e.message
        e.backtrace.map { |m| puts m }
      end

      def _not_authenticated(e)
        render_error_message 'Not Authenticated', :unauthorized, e
      end

      def _not_found(e)
        render_error_message 'Not Found', :not_found, e
      end

      def _server_error(e)
        render_error_message 'Server Error', :internal_server_error, e
      end

      module ClassMethods

      end
    end

  end
end
