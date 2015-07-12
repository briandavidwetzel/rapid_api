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
        @member = _adapter_model.find params[:id]
        render json: @member, status: :found
      end

      def create
        @member = _adapter_model.create _member_params
        render json: @member, status: :created
      end

      def update
        @member = _adapter_model.update params[:id], _member_params
        render json: @member, status: :ok
      end

      def destroy
        @member = _adapter_model.destroy params[:id]
        head :no_content
      end

      private

      def _adapter_model
        self.class.adapter_model
      end

      def _member_params
        _permitted_member_params(_member_params_key)
      end

      def _member_model
        self.class.member_model
      end

      def _member_class_name
        self.class.member_class_name
      end

      def _member_params_key
        self.class.member_params_key
      end

      module ClassMethods

        cattr_accessor :model_adapter,
                       :adapter_model,
                       :member_class_name,
                       :member_model,
                       :member_params_key

        def member_class_name
          @member_class_name || controller_name.classify.singularize
        end

        def member_model
          @member_model || member_class_name.constantize
        end

        def member_params_key
          @member_params_key || member_class_name.underscore
        end

        def model_adapter=(adapter)
          @model_adapter = adapter
          self.adapter_model = @model_adapter.new(member_model)
        end

      end

    end
  end
end
