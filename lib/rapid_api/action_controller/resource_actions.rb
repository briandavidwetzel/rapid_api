module RapidApi
  module ActionController

    module ResourceActions
      extend ActiveSupport::Concern
      include PermittedParams
      include FilterableParams
      include Errors
      include Scope

      included do
        self.serializer_adapter = RapidApi.config.serializer_adapter
        self.model_adapter      = RapidApi.config.model_adapter
      end

      def index
        query_result = _adapted_model.find_all filterable_params.to_h, scope
        render json: _adapted_serializer.serialize_collection(query_result.data), status: response_code_for(:ok)
      end

      def show
        id = _adapted_serializer.deserialize_id(params, _params_key)
        query_result = _adapted_model.find id, scope
        if query_result.found?
          render json: _adapted_serializer.serialize(query_result.data) , status: response_code_for(:ok)
        else
          not_found!
        end
      end

      def create
        attributes   = _member_params
        query_result = _adapted_model.create attributes, scope
        if query_result.has_errors?
          not_processable! _adapted_serializer.serialize_errors(query_result)
        else
          render json: _adapted_serializer.serialize(query_result.data), status: response_code_for(:created)
        end
      end

      def update
        attributes   = _member_params
        id           = _adapted_serializer.deserialize_id(params, _params_key)
        query_result = _adapted_model.update id, attributes, scope
        if query_result.found?
          if query_result.has_errors?
            not_processable! _adapted_serializer.serialize_errors(query_result)
          else
            render json: _adapted_serializer.serialize(query_result.data), status: response_code_for(:ok)
          end
        else
          not_found!
        end
      end

      def destroy
        id           = _adapted_serializer.deserialize_id(params, _params_key)
        query_result = _adapted_model.destroy id, scope
        if query_result.found?
          if query_result.has_errors?
            not_processable! query_result.errors
          else
            head :no_content
          end
        else
          not_found!
        end
      end

      def find_member
        id = _adapted_serializer.deserialize_id(params, _params_key)
        query_result = _adapted_model.find id, scope
        @member = query_result
      end

      def render_member_ok(member)
        render json: _adapted_serializer.serialize(member) , status: response_code_for(:ok)
      end

      private

      def _adapted_model
        self.class.adapted_model
      end

      def _adapted_serializer
        self.class.adapted_serializer
      end

      def _member_params
        _permitted_params_for(_adapted_serializer.deserialize_attributes(params, _params_key)).to_h
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
          module_name = self.name.to_s.deconstantize
          serializer_name = "#{model_class_name}Serializer"
          serializer_name = "#{module_name}::#{serializer_name}" unless module_name.empty?
          @serializer ||=  begin
                             serializer_name.constantize
                           rescue NameError
                           end
        end

        def serializer=(serializer)
          @serializer = serializer
          _initalize_serializer_adaper
          @serializer
        end

        def params_key
          @params_key ||= model.to_s.underscore.split('::').last
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
          @params_key = model.to_s.underscore.split('::').last
        end
      end
    end

  end
end
