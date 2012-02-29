module Amistad
  module ActiveRecordFriendModel
    def self.included(receiver)
      receiver.class_exec do
        #####################################################################################
        # friendships
        #####################################################################################
        has_many  :friendships,
          :class_name => "Amistad::Friendship::#{Amistad.friendship_model}",
          :foreign_key => "friendable_id"

        has_many  :pending_invited,
          :through => :friendships,
          :source => :friend,
          :conditions => { :'friendships.pending' => true, :'friendships.blocker_id' => nil }

        has_many  :invited,
          :through => :friendships,
          :source => :friend,
          :conditions => { :'friendships.pending' => false, :'friendships.blocker_id' => nil }

        #####################################################################################
        # inverse friendships
        #####################################################################################
        has_many  :inverse_friendships,
          :class_name => "Amistad::Friendship::#{Amistad.friendship_model}",
          :foreign_key => "friend_id"

        has_many  :pending_invited_by,
          :through => :inverse_friendships,
          :source => :friendable,
          :conditions => { :'friendships.pending' => true, :'friendships.blocker_id' => nil }

        has_many  :invited_by,
          :through => :inverse_friendships,
          :source => :friendable,
          :conditions => { :'friendships.pending' => false, :'friendships.blocker_id' => nil }

        #####################################################################################
        # blocked friendships
        #####################################################################################
        has_many  :blocked_friendships,
          :class_name => "Amistad::Friendship::#{Amistad.friendship_model}",
          :foreign_key => "blocker_id"

        has_many  :blockades,
          :through => :blocked_friendships,
          :source => :friend,
          :conditions => "friend_id <> blocker_id"

        has_many  :blockades_by,
          :through => :blocked_friendships,
          :source => :friendable,
          :conditions => "friendable_id <> blocker_id"
      end
    end

    # suggest a user to become a friend. If the operation succeeds, the method returns true, else false
    def invite(user)
      return false if user == self || find_any_friendship_with(user)
      Amistad.friendship_class.new(:friendable_id => self.id, :friend_id => user.id).save
    end

    # approve a friendship invitation. If the operation succeeds, the method returns true, else false
    def approve(user)
      friendship = find_any_friendship_with(user)
      return false if friendship.nil? || invited?(user)
      friendship.update_attribute(:pending, false)
    end

    # deletes a friendship
    def remove_friendship(user)
      friendship = find_any_friendship_with(user)
      return false if friendship.nil?
      friendship.destroy && friendship.destroyed?
    end

    # returns the list of approved friends
    def friends
      self.invited(true) + self.invited_by(true)
    end

    # total # of invited and invited_by without association loading
    def total_friends
      self.invited(false).count + self.invited_by(false).count
    end

    # blocks a friendship
    def block(user)
      friendship = find_any_friendship_with(user)
      return false if friendship.nil? || !friendship.can_block?(self)
      friendship.update_attribute(:blocker, self)
    end

    # unblocks a friendship
    def unblock(user)
      friendship = find_any_friendship_with(user)
      return false if friendship.nil? || !friendship.can_unblock?(self)
      friendship.update_attribute(:blocker, nil)
    end

    # returns the list of blocked friends
    def blocked
      self.blockades(true) + self.blockades_by(true)
    end

    # total # of blockades and blockedes_by without association loading
    def total_blocked
      self.blockades(false).count + self.blockades_by(false).count
    end

    # checks if a user is blocked
    def blocked?(user)
      blocked.include?(user)
    end

    # checks if a user is a friend
    def friend_with?(user)
      friends.include?(user)
    end

    # checks if a current user is connected to given user
    def connected_with?(user)
      find_any_friendship_with(user).present?
    end

    # checks if a current user received invitation from given user
    def invited_by?(user)
      friendship = find_any_friendship_with(user)
      return false if friendship.nil?
      friendship.friendable == user
    end

    # checks if a current user invited given user
    def invited?(user)
      friendship = find_any_friendship_with(user)
      return false if friendship.nil?
      friendship.friend == user
    end

    # return the list of the ones among its friends which are also friend with the given use
    def common_friends_with(user)
      self.friends & user.friends
    end

    # returns friendship with given user or nil
    def find_any_friendship_with(user)
      friendship = Amistad.friendship_class.where(:friendable_id => self.id, :friend_id => user.id).first
      if friendship.nil?
        friendship = Amistad.friendship_class.where(:friendable_id => user.id, :friend_id => self.id).first
      end
      friendship
    end
  end
end
