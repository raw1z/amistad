module Amistad
  module MongoidFriendModel
    extend ActiveSupport::Concern

    included do
      field :friend_ids,
        :type => Array,
        :default => []

      field :inverse_friend_ids,
        :type => Array,
        :default => []

      field :pending_friend_ids,
        :type => Array,
        :default => []

      field :pending_inverse_friend_ids,
        :type => Array,
        :default => []

      field :blocked_friend_ids,
        :type => Array,
        :default => []

      field :blocked_inverse_friend_ids,
        :type => Array,
        :default => []

      field :blocked_pending_friend_ids,
        :type => Array,
        :default => []

      field :blocked_pending_inverse_friend_ids,
        :type => Array,
        :default => []

      attr_accessible(
        :friend_ids,
        :inverse_friend_ids,
        :pending_friend_ids,
        :pending_inverse_friend_ids,
        :blocked_friend_ids,
        :blocked_inverse_friend_ids,
        :blocked_pending_friend_ids,
        :blocked_pending_inverse_friend_ids,
      )
    end
  end
end
