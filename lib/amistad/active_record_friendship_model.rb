module Amistad
  module ActiveRecordFriendshipModel
    extend ActiveSupport::Concern

    included do
      belongs_to :friendable,
        :class_name => Amistad.friend_model,
        :foreign_key => "friendable_id"

      belongs_to :friend,
        :class_name => Amistad.friend_model,
        :foreign_key => "friend_id"

      belongs_to :blocker,
        :class_name => Amistad.friend_model,
        :foreign_key => "blocker_id"

      validates_presence_of :friendable_id, :friend_id
      validates_uniqueness_of :friend_id, :scope => :friendable_id
    end

    # returns true if a friendship has been approved, else false
    def approved?
      !self.pending
    end

    # returns true if a friendship has not been approved, else false
    def pending?
      self.pending
    end

    # returns true if a friendship has been blocked, else false
    def blocked?
      self.blocker_id.present?
    end

    # returns true if a friendship has not beed blocked, else false
    def active?
      self.blocker_id.nil?
    end

    # returns true if a friendship can be blocked by given friendable
    def can_block?(friendable)
      active? && (approved? || (pending? && self.friend_id == friendable.id && friendable.class.to_s == Amistad.friend_model))
    end

    # returns true if a friendship can be unblocked by given friendable
    def can_unblock?(friendable)
      blocked? && self.blocker_id == friendable.id && friendable.class.to_s == Amistad.friend_model
    end
  end
end
