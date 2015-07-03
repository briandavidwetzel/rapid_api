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

      def _member_model
        self.class.member_model_class
      end

      def _collection_model
        self.class.collection_model
      end

      module ClassMethods

        def member_model
          controller_name.classify.singularize.constantize
        end

        def collection_model
          member_model
        end

      end

    end
  end
end
