module Amistad
  module FriendModel
    def self.included(receiver)
      if receiver.ancestors.map(&:to_s).include?("ActiveRecord::Base")
        receiver.class_exec do
          include Amistad::ActiveRecordFriendModel
        end
      elsif receiver.ancestors.map(&:to_s).include?("Mongoid::Document")
        receiver.class_exec do
          include Amistad::MongoidFriendModel
        end
      else
        raise "Amistad only supports ActiveRecord and Mongoid"
      end
    end
  end
end