module RapidApi
  module ActionController

    module Errors
      extend ActiveSupport::Concern

      NotAuthenticatedError = Class.new StandardError
      NotFoundError         = Class.new StandardError

      class NotProcessableError < StandardError
        attr_accessor :errors

        def initialize(errors)
          @errors = errors
        end

      end

      included do
        rescue_from StandardError,         with: :_server_error
        rescue_from NotAuthenticatedError, with: :_not_authenticated
        rescue_from NotFoundError,         with: :_not_found
        rescue_from NotProcessableError,   with: :_not_processable
      end

      def not_authenticated!
        raise NotAuthenticatedError
      end

      def not_found!
        raise NotFoundError
      end

      def not_processable!(errors)
        raise NotProcessableError.new(errors)
      end

      protected

      def render_error_message(message, status, e)
        render json: { errors: [message] }, status: response_code_for(status)
      end

      def response_code_for(status)
        RapidApi.config.response_codes[status]
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

      def _not_processable(e)
        render json: { errors: e.errors }, status: response_code_for(:unprocessable_entity)
      end

      def _server_error(e)
        render_error_message "Server Error: #{e.message}", :internal_server_error, e
      end

      module ClassMethods

      end
    end

  end
end
