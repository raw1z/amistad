module Amistad
  module MongoFriendModel
    # suggest a user to become a friend. If the operation succeeds, the method returns true, else false
    def invite(user)
      return false if friendshiped_with?(user) or user == self or blocked?(user)
      pending_friend_ids << user.id
      user.pending_inverse_friend_ids << self.id
      self.save && user.save
    end

    # approve a friendship invitation. If the operation succeeds, the method returns true, else false
    def approve(user)
      return false unless pending_inverse_friend_ids.include?(user.id) && user.pending_friend_ids.include?(self.id)
      pending_inverse_friend_ids.delete(user.id)
      user.pending_friend_ids.delete(self.id)
      inverse_friend_ids << user.id
      user.friend_ids << self.id
      self.save && user.save
    end

    # returns the list of approved friends
    def friends
      self.invited + self.invited_by
    end

    # total # of invited and invited_by without association loading
    def total_friends
      (friend_ids + inverse_friend_ids).count
    end

    # return the list of invited friends
    def invited
      self.class.find(friend_ids)
    end

    # return the list of friends who invited
    def invited_by
      self.class.find(inverse_friend_ids)
    end

    # return the list of pending invited friends
    def pending_invited
      self.class.find(pending_friend_ids)
    end

    # return the list of pending friends who invited
    def pending_invited_by
      self.class.find(pending_inverse_friend_ids)
    end

    # return the list of the ones among its friends which are also friend with the given use
    def common_friends_with(user)
      self.friends & user.friends
    end

    # checks if a user is a friend
    def friend_with?(user)
      return false if user == self
      (friend_ids + inverse_friend_ids).include?(user.id)
    end

    # checks if a current user is connected to given user
    def connected_with?(user)
      friendshiped_with?(user)
    end

    # checks if a current user received invitation from given user
    def invited_by?(user)
      user.friend_ids.include?(self.id) or user.pending_friend_ids.include?(self.id)
    end

    # checks if a current user invited given user
    def invited?(user)
      self.friend_ids.include?(user.id) or self.pending_friend_ids.include?(user.id)
    end

    # deletes a friendship
    def remove_friendship(user)
      friend_ids.delete(user.id)
      user.inverse_friend_ids.delete(self.id)
      inverse_friend_ids.delete(user.id)
      user.friend_ids.delete(self.id)
      pending_friend_ids.delete(user.id)
      user.pending_inverse_friend_ids.delete(self.id)
      pending_inverse_friend_ids.delete(user.id)
      user.pending_friend_ids.delete(self.id)
      self.save && user.save
    end

    # blocks a friendship
    def block(user)
      if inverse_friend_ids.include?(user.id)
        inverse_friend_ids.delete(user.id)
        user.friend_ids.delete(self.id)
        blocked_inverse_friend_ids << user.id
      elsif pending_inverse_friend_ids.include?(user.id)
        pending_inverse_friend_ids.delete(user.id)
        user.pending_friend_ids.delete(self.id)
        blocked_pending_inverse_friend_ids << user.id
      elsif friend_ids.include?(user.id)
        friend_ids.delete(user.id)
        user.inverse_friend_ids.delete(user.id)
        blocked_friend_ids << user.id
      else
        return false
      end

      self.save
    end

    # unblocks a friendship
    def unblock(user)
      if blocked_inverse_friend_ids.include?(user.id)
        blocked_inverse_friend_ids.delete(user.id)
        user.blocked_friend_ids.delete(self.id)
        inverse_friend_ids << user.id
        user.friend_ids << self.id
      elsif blocked_pending_inverse_friend_ids.include?(user.id)
        blocked_pending_inverse_friend_ids.delete(user.id)
        pending_inverse_friend_ids << user.id
        user.pending_friend_ids << self.id
      elsif blocked_friend_ids.include?(user.id)
        blocked_friend_ids.delete(user.id)
        user.blocked_inverse_friend_ids.delete(self.id)
        friend_ids << user.id
        user.inverse_friend_ids << self.id
      else
        return false
      end

      self.save && user.save
    end

    # returns the list of blocked friends
    def blocked
      blocked_ids = blocked_friend_ids + blocked_inverse_friend_ids + blocked_pending_inverse_friend_ids
      self.class.find(blocked_ids)
    end

    # total # of blockades and blockedes_by without association loading
    def total_blocked
      (blocked_friend_ids + blocked_inverse_friend_ids + blocked_pending_inverse_friend_ids).count
    end

    # checks if a user is blocked
    def blocked?(user)
      (blocked_friend_ids + blocked_inverse_friend_ids + blocked_pending_inverse_friend_ids).include?(user.id) or user.blocked_pending_inverse_friend_ids.include?(self.id)
    end

    # check if any friendship exists with another user
    def friendshiped_with?(user)
      (friend_ids + inverse_friend_ids + pending_friend_ids + pending_inverse_friend_ids + blocked_friend_ids).include?(user.id)
    end

    # deletes all the friendships
    def delete_all_friendships
      friend_ids.clear
      inverse_friend_ids.clear
      pending_friend_ids.clear
      pending_inverse_friend_ids.clear
      blocked_friend_ids.clear
      blocked_inverse_friend_ids.clear
      blocked_pending_friend_ids.clear
      blocked_pending_inverse_friend_ids.clear
      self.save
    end
  end
end
