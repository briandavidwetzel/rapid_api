module RestfulApi
  module ActionController
    module RestActions
      include ActiveSupport::Concern

      def index
        render json: {}, status: :ok
      end

    end
  end
end
