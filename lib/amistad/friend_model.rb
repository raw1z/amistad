module Amistad
  module FriendModel
    def self.included(receiver)
      receiver.class_exec do
        include InstanceMethods
        
        has_many  :friendships
        
        has_many  :pending_invited,
                  :through => :friendships,
                  :source => :friend,
                  :conditions => { :'friendships.pending' => true, :'friendships.blocked' => false }
                  
        has_many  :invited,
                  :through => :friendships,
                  :source => :friend,
                  :conditions => { :'friendships.pending' => false, :'friendships.blocked' => false }

        has_many  :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
        
        has_many  :pending_invited_by,
                  :through => :inverse_friendships,
                  :source => :user,
                  :conditions => { :'friendships.pending' => true, :'friendships.blocked' => false }
                  
        has_many  :invited_by,
                  :through => :inverse_friendships,
                  :source => :user,
                  :conditions => { :'friendships.pending' => false, :'friendships.blocked' => false }
                  
        has_many  :blocked,
                  :through => :inverse_friendships,
                  :source => :user,
                  :conditions => { :'friendships.blocked' => true }
      end
    end

    module InstanceMethods
      # suggest a user to become a friend. If the operation succeeds, the method returns true, else false
      def invite(user)
        return false if user == self
        
        friendship = find_any_friendship_with(user)
        return false if not friendship.nil?
        
        friendship = Friendship.new(:user_id => self.id, :friend_id => user.id)
        friendship.save
      end
      
      # approve a friendship invitation. If the operation succeeds, the method returns true, else false
      def approve(user)
        friendship = find_any_friendship_with(user)
        return false if friendship.nil?
        friendship.pending = false
        friendship.save
      end
      
      # returns the list of approved friends
      def friends
        self.invited(true) + self.invited_by(true)
      end
      
      # blocks a friendship request
      def block(user)
        friendship = find_any_friendship_with(user)
        return false if friendship.nil?
        friendship.blocked = true
        friendship.pending = false
        friendship.save
      end
      
      # deletes a friendship
      def remove(user)
        friendship = find_any_friendship_with(user)
        return false if friendship.nil?
        friendship.destroy
        friendship.destroyed?
      end
      
      # checks if a user is a friend
      def is_friend_with?(user)
        friends.include?(user)
      end
      
      # checks if a user send a friendship's invitation
      def was_invited_by?(user)
        inverse_friendships.each do |friendship|
          return true if friendship.user == user
        end
        false
      end
      
      # return the list of the ones among its friends which are also friend with the given use
      def common_friends_with(user)
        self.friends & user.friends
      end
      
      private
      
      def find_any_friendship_with(user)
        friendship = Friendship.where(:user_id => self.id, :friend_id => user.id).first
        if friendship.nil?
          friendship = Friendship.where(:user_id => user.id, :friend_id => self.id).first
        end
        friendship
      end
      
    end    
  end
end

