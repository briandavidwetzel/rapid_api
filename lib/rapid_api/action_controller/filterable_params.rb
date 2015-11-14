module RapidApi
  module ActionController

    module FilterableParams
      extend ActiveSupport::Concern

      included do

      end

      def filterable_params
        params.permit(self.class.permitted_filterable_params)
      end

      module ClassMethods
        attr_accessor :permitted_filterable_params

        def permitted_filterable_params
          @filterable_params ||= []
        end

        def filterable_params(*params)
          [*params].each { |p| self.permitted_filterable_params << p }
        end
      end
    end

  end
end
