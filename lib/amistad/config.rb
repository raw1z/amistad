module Amistad
  class << self
    attr_accessor :friend_model

    def configure
      yield self
    end

    def friend_model
      @friend_model || 'User'
    end

    def friendship_model
      "#{self.friend_model}Friendship"
    end

    def friendship_class
      Amistad::Friendships.const_get(self.friendship_model)
    end
  end
end
