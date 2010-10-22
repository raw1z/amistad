module Amistad
  module FriendshipModel
    
    def self.included(receiver)
      receiver.class_exec do
        include InstanceMethods
        
        belongs_to :user
        belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
        
        validates_presence_of :user_id, :friend_id
        validates_uniqueness_of :friend_id, :scope => :user_id
      end
    end
    
    module InstanceMethods
      # returns true if a friendship has not been approved, else false
      def pending?
        self.pending
      end
      
      # returns true if a friendship has been blocked, else false
      def blocked?
        self.blocked
      end
    end
    
  end
end
