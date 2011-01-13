module Amistad
  module FriendshipModel
    def self.included(receiver)
      if receiver.ancestors.map(&:to_s).include?("ActiveRecord::Base")
        receiver.class_exec do
          include Amistad::ActiveRecord::FriendshipModel
        end
      elsif receiver.ancestors.map(&:to_s).include?("Mongoid::Document")
        receiver.class_exec do
          include Amistad::Mongoid::FriendshipModel
        end
      end
    end
  end
end