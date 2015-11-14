module RapidApi
  module ActionController

    module Scope
      extend ActiveSupport::Concern

      attr_accessor :scope

      included do
        before_filter :define_scope
      end

      def scope
        @scope ||= {}
      end

      protected

      def define_scope
        scope_by = self.class.scope_by_proc.call(self)
        scope_by_array = [*scope_by]
        self.class.scope_params.each_with_index do |key, index|
          scope[key] = scope_by_array[index]
        end
      end


      module ClassMethods
        attr_accessor :scope_by_proc, :scope_params

        def scope_params
          @scope_params ||= []
        end

        def scope_by(*params, &block)
          self.scope_by_proc = Proc.new { |p| block.call(p) }
          [*params].each { |p| self.scope_params << p }
        end
      end
    end

  end
end
