# encoding: UTF-8

module ADN
  class Post
    attr_accessor :post_id, :created_at, :entities,
                  :html, :id, :num_replies, :reply_to,
                  :source, :text, :thread_id, :user

    def self.send(params)
      result = ADN::API::Post.new(params)
      Post.new(result["data"]) unless result.has_error?
    end

    def initialize(raw_post)
      if raw_post.is_a? Hash
        raw_post.each do |k, v|
          self.instance_variable_set "@#{k}", v
        end
        @post_id = @id
      else
        @post_id = raw_post
        details = self.details
        if details.has_key? "data"
          details["data"].each do |k, v|
            self.instance_variable_set "@#{k}", v
          end
        end
      end
    end

    def details
      if self.id
        h = {}
        self.instance_variables.each { |iv|
          h[iv.to_s.gsub(/[^a-zA-Z0-9_]/, '')] = self.instance_variable_get(iv)
        }
        h
      else
        ADN::API::Post.by_id(@post_id)
      end
    end

    def created_at
      DateTime.parse(@created_at)
    end

    def user
      ADN::User.new @user
    end

    def reply_to_post
      result = ADN::API::Post.by_id @reply_to
      Post.new(result["data"]) unless result.has_error?
    end

    def replies(params = nil)
      result = ADN::API::Post.replies(@id, params)
      result["data"].collect { |p| Post.new(p) } unless result.has_error?
    end

    def delete
      result = ADN::API::Post.delete(@id)
      Post.new(result["data"]) unless result.has_error?
    end
  end
end