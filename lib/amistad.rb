require 'active_support/concern'
require 'active_support/dependencies/autoload'

module Amistad
  extend ActiveSupport::Autoload

  autoload :ActiveRecordFriendModel
  autoload :ActiveRecordFriendshipModel
  autoload :MongoidFriendModel
  autoload :FriendshipModel
  autoload :FriendModel
  autoload :Friendship

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
      Amistad::Friendship.const_get(self.friendship_model)
    end
  end
end
