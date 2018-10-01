require File.expand_path '../../../../test_helper.rb', __FILE__

module RapidApi
  module Services
    class BaseServiceTest < Minitest::Test
    
      def setup
        @service = BrickService
      end

      def test_response_without_errors
        service_response = @service.without_errors(value: 'red bricks')
        refute service_response.has_errors?
      end

      def test_response_with_errors
        service_response = @service.with_errors
        assert service_response.has_errors?
      end

      def test_response_value
        value = 'red bricks'
        service_response = @service.without_errors(value: value)
        assert_equal value, service_response.value
      end

      def test_response_errors
        error_key = 'foo'
        error_message = 'bar'
        errors = {}
        errors[error_key] = [ error_message ]
        service_response = @service.with_errors(key: error_key, message: error_message)
        assert_equal errors, service_response.errors
      end

      def test_bang_mode
        value = 'yellow bricks'
        service_response = @service.without_errors!(value: value)
        assert_equal value, service_response
      end

      def test_bang_mode_error
        error_key = 'foo'
        error_message = 'bar'
        exception_message = "#{error_key}: #{error_message}"
        assert_raises exception_message do
          @service.with_errors!(key: error_key, message: error_message)
        end
      end
    end
  end
end