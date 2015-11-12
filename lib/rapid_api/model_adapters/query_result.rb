module RapidApi
  module ModelAdapters

    class QueryResult
      attr_accessor :errors, :data

      def initialize(data: nil, errors: nil)
        @data   = data
        @errors = errors
      end

      def has_errors?
        errors.present?
      end
    end

  end
end
