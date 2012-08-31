# encoding: UTF-8

module ADN
  module API
    module User
      def self.retrieve(user_id)
        ADN.get("/stream/0/users/#{user_id}")
      end

      def self.by_id(user_id)
        self.retrieve(user_id)
      end

      def self.following(user_id)
        ADN.get("/stream/0/users/#{user_id}/following")
      end

      def self.followers(user_id)
        ADN.get("/stream/0/users/#{user_id}/followers")
      end
    end
  end
end