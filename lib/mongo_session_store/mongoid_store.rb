require 'mongoid'
require 'mongo_session_store/mongo_store_base'

module ActionDispatch
  module Session
    class MongoidStore < MongoStoreBase

      class Session
        include Mongoid::Document
        include Mongoid::Timestamps

        store_in :collection => MongoSessionStore.collection_name

        field :_id, :type => String

        field :data, :type => BSON::Binary, :default => BSON::Binary.new(Marshal.dump({}), :generic)

      end

      private

      def pack(data)
        BSON::Binary.new(Marshal.dump(data), :generic)
      end

      def unpack(packed)
        return nil unless packed
        Marshal.load(StringIO.new(packed.data.to_s))
      end
    end
  end
end

MongoidStore = ActionDispatch::Session::MongoidStore
