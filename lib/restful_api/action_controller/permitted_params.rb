module RestfulApi
  module ActionController

    module PermittedParams
      extend ActiveSupport::Concern

      included do

      end

      def permitted_params
        self.class.permitted_params
      end

      private

      def _permitted_params_for(key)
        params.require(key).permit(*permitted_params)
      end


      module ClassMethods

        def permit_params(*params)
          @permitted_params ||= []
          @permitted_params += params
          @permitted_params.uniq!
        end

        def permitted_params
          @permitted_params
        end

      end
    end

  end
end
