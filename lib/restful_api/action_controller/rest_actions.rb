require 'restful_api/action_controller/permitted_params'

module RestfulApi
  module ActionController
    module RestActions
      extend ActiveSupport::Concern
      include PermittedParams

      included do
      end

      def index
        @collection = _adapted_model.find_all
        render json: @collection, status: :found
      end

      def show
        @member = _adapted_model.find params[:id]
        render json: _serializer_adapter.serialize(@member) , status: :found
      end

      def create
        @member = _adapted_model.create _member_params
        render json: _serializer_adapter.serialize(@member), status: :created
      end

      def update
        @member = _adapted_model.update params[:id], _member_params
        render json: _serializer_adapter.serialize(@member), status: :ok
      end

      def destroy
        @member = _adapted_model.destroy params[:id]
        head :no_content
      end

      private

      def _adapted_model
        self.class.adapted_model
      end

      def _serializer_adapter
        self.class.serializer_adapter
      end

      def _member_params
        _permitted_params_for(_params_key)
      end

      def _model
        self.class.model
      end

      def _params_key
        self.class.params_key
      end

      module ClassMethods

        cattr_accessor :model_class_name,
                       :model,
                       :model_adapter,
                       :adapted_model,
                       :params_key,
                       :serializer_adapter

        def model_class_name
          @@model_class_name || controller_name.classify.singularize
        end

        def model
          @@model || model_class_name.constantize
        end

        def params_key
          @@params_key || model_class_name.underscore
        end

        def model_adapter=(adapter)
          @@model_adapter = adapter
          self.adapted_model = @@model_adapter.new(model)
        end

      end

    end
  end
end
