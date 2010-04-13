module Amistad
  module FriendshipModel
    
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def acts_as_friendship
        belongs_to :user
        belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
        
        validates_presence_of :user_id, :friend_id
        
        class_eval <<-EOV
          include Amistad::FriendshipModel::InstanceMethods
        EOV
      end
    end
    
    module InstanceMethods
      def pending?
        self.pending
      end
    end
    
  end
end

class ActiveRecord::Base
  include Amistad::FriendshipModel
end
