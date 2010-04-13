module Amistad
  module FriendModel
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_friend
        has_many  :friendships
        
        has_many  :pending_invited,
                  :through => :friendships,
                  :source => :friend,
                  :conditions => { :'friendships.pending' => true }
                  
        has_many  :invited,
                  :through => :friendships,
                  :source => :friend,
                  :conditions => { :'friendships.pending' => false }

        has_many  :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
        
        has_many  :pending_invited_by,
                  :through => :inverse_friendships,
                  :source => :user,
                  :conditions => {:'friendships.pending' => true}
                  
        has_many  :invited_by,
                  :through => :inverse_friendships,
                  :source => :user,
                  :conditions => {:'friendships.pending' => false}
        
        class_eval <<-EOV
          include Amistad::FriendModel::InstanceMethods
        EOV
      end
    end

    module InstanceMethods
      def invite(user)
        return false if user == self
        
        friendship = find_any_friendship_with(user)
        return false if not friendship.nil?
        
        friendship = Friendship.new(:user_id => self.id, :friend_id => user.id)
        friendship.save
      end
      
      def approve(user)
        friendship = find_any_friendship_with(user)
        return false if friendship.nil?
        friendship.pending = false
        friendship.save
      end
      
      def friends
        self.invited(true) + self.invited_by(true)
      end
      
      def remove(user)
        friendship = find_any_friendship_with(user)
        return false if friendship.nil?
        friendship.destroy
        friendship.destroyed?
      end
      
      def is_friend_with?(user)
        friends.include?(user)
      end
      
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

class ActiveRecord::Base
  include Amistad::FriendModel
end
