module RapidApi
  module ActionController

    module RestActions
      extend ActiveSupport::Concern
      include PermittedParams
      include Errors
      include Scope

      included do
        self.serializer_adapter = RapidApi.config.serializer_adapter
        self.model_adapter      = RapidApi.config.model_adapter
      end

      def index
        query_result = _adapted_model.find_all nil, scope 
        render json: _adapted_serializer.serialize_collection(query_result.data), status: response_code_for(:ok)
      end

      def show
        query_result = _adapted_model.find params[:id], scope
        if query_result.found?
          render json: _adapted_serializer.serialize(query_result.data) , status: response_code_for(:ok)
        else
          not_found!
        end
      end

      def create
        query_result = _adapted_model.create _member_params, scope
        if query_result.has_errors?
          not_processable! query_result.errors
        else
          render json: _adapted_serializer.serialize(query_result.data), status: response_code_for(:created)
        end
      end

      def update
        query_result = _adapted_model.update params[:id], _member_params, scope
        if query_result.found?
          if query_result.has_errors?
            not_processable! query_result.errors
          else
            render json: _adapted_serializer.serialize(query_result.data), status: response_code_for(:ok)
          end
        else
          not_found!
        end
      end

      def destroy
        query_result = _adapted_model.destroy params[:id], scope
        if query_result.has_errors?
          not_processable! query_result.errors
        else
          head :no_content
        end
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

        attr_accessor :model_class_name,
                      :model,
                      :model_adapter,
                      :adapted_model,
                      :params_key,
                      :serializer,
                      :serializer_adapter,
                      :adapted_serializer

        def model_class_name
          @model_class_name ||= controller_name.classify.singularize
        end

        def model
          @model ||= begin
                      model_class_name.constantize
                     rescue NameError
                     end
        end

        def model=(model)
          @model = model
          _reset_params_key
          _initialize_model_adapter
          @model
        end

        def serializer
          #TODO: BDW - This convention is too dependent on AMS. This should be
          # decoupled in some way.
          @serializer ||=  begin
                             "#{model_class_name}Serializer".constantize
                           rescue NameError
                           end
        end

        def serializer=(serializer)
          @serializer = serializer
          _initalize_serializer_adaper
          @serializer
        end

        def params_key
          @params_key ||= model.to_s.underscore
        end

        def model_adapter=(adapter)
          @model_adapter = adapter
          _initialize_model_adapter
        end

        def serializer_adapter=(adapter)
          @serializer_adapter = adapter
          _initalize_serializer_adaper
        end

        private

        def _initalize_serializer_adaper
          self.adapted_serializer = @serializer_adapter.new(serializer, params_key)
        end

        def _initialize_model_adapter
          self.adapted_model = @model_adapter.new(model)
        end

        def _reset_params_key
          @params_key = model.to_s.underscore
        end
      end
    end

  end
end
