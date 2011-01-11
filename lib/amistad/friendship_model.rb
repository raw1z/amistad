module Amistad
  module FriendshipModel
    def self.included(receiver)
      if receiver.ancestors.map(&:to_s).include?("ActiveRecord::Base")
        receiver.class_exec do
          include Amistad::ActiveRecord::FriendshipModel
        end
      end
    end
  end
end