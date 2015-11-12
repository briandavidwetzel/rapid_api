module RapidApi
  module ModelAdapters
    class ActiveRecordAdapter < Abstract

      def find(id)
        member = klass.where(id: id).first
        QueryResult.new data: member
      end

      def find_all(params=nil)
        collection = klass.all
        QueryResult.new data: collection
      end

      def create(params)
        member = klass.create params
        _query_result_for_member member
      end

      def update(id, params)
        member = klass.find id
        member.update_attributes params
        _query_result_for_member member
      end

      def destroy(id)
        member = klass.find id
        member.destroy
        _query_result_for_member member
      end

      private

      def _query_result_for_member(member)
        QueryResult.new data: member, errors: member.errors
      end

    end
  end
end
