module RestfulApi
  module ModelAdapters
    class ActiveRecordAdapter < Abstract

      def find(id)
        klass.find id
      end

      def find_all(params=nil)
        klass.all
      end

      def create(params)
        klass.create params
      end

      def update(id, params)
        member = klass.find id
        member.update_attributes params
        member
      end

      def destroy(id)
        klass.destroy id
      end

    end
  end
end
