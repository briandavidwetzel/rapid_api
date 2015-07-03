require 'restful_api/action_controller/permitted_params'

module RestfulApi
  module ActionController
    module RestActions
      extend ActiveSupport::Concern
      include PermittedParams

      included do

      end

      def index
        render head :no_content
      end

      def show
        render head :no_content
      end

      def create
        render head :no_content
      end

      def update
        render head :no_content
      end

      def destroy
        render head :no_content
      end

      private

      def _member_params
        _permitted_member_params(_member_params_key)
      end

      def _member_model
        self.class.member_model_class
      end

      def _collection_model
        self.class.collection_model
      end

      def _member_class_name
        self.class.member_class_name
      end

      def _member_params_key
        self.class.member_params_key
      end

      module ClassMethods

        def member_class_name
          controller_name.classify.singularize
        end

        def member_model
          member_class_name.constantize
        end

        def member_params_key
          member_class_name.underscore
        end

        def collection_model
          member_model
        end

      end

    end
  end
end
