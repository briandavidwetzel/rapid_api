module RapidApi
  module ActionController

    module Scope
      extend ActiveSupport::Concern

      attr_accessor :scope

      def scope
        @scope ||= {}
      end

      def define_scope
        tmp_scope_array = [*_scope_array]
        self.class.scope_params.each_with_index do |key, index|
          scope[key] = tmp_scope_array[index]
        end
      end

      protected

      def _scope_array
        []
      end

      module ClassMethods
        attr_accessor :scope_by_proc, :scope_params

        def scope_params
          @scope_params ||= []
        end

        def scope_by(*params, &block)
          define_method :_scope_array, &block
          before_action(:define_scope)
          [*params].each { |p| self.scope_params << p }
        end
      end
    end

  end
end
