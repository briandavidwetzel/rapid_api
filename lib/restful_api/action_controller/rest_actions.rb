module RestfulApi
  module ActionController
    module RestActions
      extend ActiveSupport::Concern

      included do

      end

      def index
        render json: {}, status: :ok
      end

      private


    end
  end
end
