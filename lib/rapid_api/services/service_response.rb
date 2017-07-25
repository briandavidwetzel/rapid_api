module RapidApi
  module Services
    class ServiceResponse
      attr_accessor :value, :errors

      def has_errors?
        !errors.empty?
      end

      def errors
        @errors ||= HashWithIndifferentAccess.new
      end

    end
  end
end
