module RestfulApi
  module ActionController
    module RestActions
      extend ActiveSupport::Concern

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

    end
  end
end
