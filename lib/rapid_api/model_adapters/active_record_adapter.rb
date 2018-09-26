module RapidApi
  module ModelAdapters
    class ActiveRecordAdapter < Abstract

      def find(id, scope=nil)
        member = _find_member_with_scope(id, scope)
        QueryResult.new data: member
      end

      def find_all(params={}, scope={})
        scoped_params = params.merge scope
        collection = klass.where(scoped_params)
        QueryResult.new data: collection
      end

      def create(params, scope={})
        create_params = params.merge scope
        member = klass.create create_params
        _query_result_for_member member
      end

      def update(id, params, scope=nil)
        member = _find_member_with_scope(id, scope)
        if member.present?
          member.update_attributes params
        end
        _query_result_for_member member
      end

      def destroy(id, scope=nil)
        member = _find_member_with_scope(id, scope)
        if member.present?
          member.destroy
        end
        _query_result_for_member member
      end

      private

      def _query_result_for_member(member)
        QueryResult.new data: member, errors: member.try(:errors)
      end

      def _find_member_with_scope(id, scope)
        klass.where(scope).where(id: id).first
      end

    end
  end
end
