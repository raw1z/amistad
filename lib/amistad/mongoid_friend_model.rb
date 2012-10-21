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

      %w(friend_ids inverse_friend_ids pending_friend_ids pending_inverse_friend_ids blocked_friend_ids blocked_inverse_friend_ids blocked_pending_friend_ids blocked_pending_inverse_friend_ids).each do |attribute|
        define_method(attribute.to_sym) do
          value = read_attribute(attribute)
          write_attribute(attribute, value = []) if value.nil?
          value
        end
      end
    end
  end
end
