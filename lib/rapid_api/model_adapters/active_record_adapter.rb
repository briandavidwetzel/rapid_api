module RapidApi
  module ModelAdapters
    class ActiveRecordAdapter < Abstract

      def find(id, scope=nil)
        member = _find_member_with_scope(id, scope)
        QueryResult.new data: member
      end

      def find_all(params=nil, scope=nil)
        params ||= {}
        scope  ||= {}
        scoped_params = params.merge scope
        collection = klass.where(scoped_params)
        QueryResult.new data: collection
      end

      def create(params, scope=nil)
        scope ||= {}
        create_params = params.merge scope
        member = klass.create create_params
        _query_result_for_member member
      end

      def update(id, params, scope=nil)
        member = _find_member_with_scope(id, scope)
        member.update_attributes params
        _query_result_for_member member
      end

      def destroy(id, scope=nil)
        member = _find_member_with_scope(id, scope)
        member.destroy
        _query_result_for_member member
      end

      private

      def _query_result_for_member(member)
        QueryResult.new data: member, errors: member.errors
      end

      def _find_member_with_scope(id, scope)
        klass.where(scope).where(id: id).first
      end

    end
  end
end
