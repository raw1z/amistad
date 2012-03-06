module Amistad
  module Friendships
    if Object.const_defined? :ActiveRecord
      const_set Amistad.friendship_model, Class.new(ActiveRecord::Base)
      const_get(Amistad.friendship_model.to_sym).class_exec do
        include Amistad::FriendshipModel
        self.table_name = 'friendships'
      end
    elsif Object.const_defined? :Mongoid
      Friendship = Class.new
      Friendship.class_exec do
        include Mongoid::Document
        include Amistad::FriendshipModel
      end
    else
      raise "Amistad only supports ActiveRecord and Mongoid"
    end
  end
end
