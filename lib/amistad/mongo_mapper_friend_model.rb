module Amistad
  module MongoMapperFriendModel
    extend ActiveSupport::Concern

    included do
      key :friend_ids,
        Array,
        :default => []

      key :inverse_friend_ids,
        Array,
        :default => []

      key :pending_friend_ids,
        Array,
        :default => []

      key :pending_inverse_friend_ids,
        Array,
        :default => []

      key :blocked_friend_ids,
        Array,
        :default => []

      key :blocked_inverse_friend_ids,
        Array,
        :default => []

      key :blocked_pending_friend_ids,
        Array,
        :default => []

      key :blocked_pending_inverse_friend_ids,
        Array,
        :default => []

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
