require 'restful_api/action_controller/permitted_params'

module RestfulApi
  module ActionController
    module RestActions
      extend ActiveSupport::Concern
      include PermittedParams

      included do
        self.serializer_adapter = RestfulApi.config.serializer_adapter
        self.model_adapter      = RestfulApi.config.model_adapter
      end

      def index
        @collection = _adapted_model.find_all
        render json: @collection, status: :found
      end

      def show
        @member = _adapted_model.find params[:id]
        render json: _adapted_serializer.serialize(@member) , status: :found
      end

      def create
        @member = _adapted_model.create _member_params
        render json: _adapted_serializer.serialize(@member), status: :created
      end

      def update
        @member = _adapted_model.update params[:id], _member_params
        render json: _adapted_serializer.serialize(@member), status: :ok
      end

      def destroy
        @member = _adapted_model.destroy params[:id]
        head :no_content
      end

      private

      def _adapted_model
        self.class.adapted_model
      end

      def _adapted_serializer
        self.class.adapted_serializer
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
                       :serializer,
                       :serializer_adapter,
                       :adapted_serializer

        def model_class_name
          @@model_class_name || controller_name.classify.singularize
        end

        def model
          @@model || model_class_name.constantize
        end

        def serializer
          @@serializer || "#{model_class_name}Serializer".constantize
        end

        def params_key
          @@params_key || model_class_name.underscore
        end

        def model_adapter=(adapter)
          @@model_adapter    = adapter
          self.adapted_model = @@model_adapter.new(model)
        end

        def serializer_adapter=(adapter)
          @@serializer_adapter    = adapter
          self.adapted_serializer = @@serializer_adapter.new(serializer)
        end

      end

    end
  end
end
