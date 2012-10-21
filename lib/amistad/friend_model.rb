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
          include Amistad::MongoFriendModel
        end
      elsif receiver.ancestors.map(&:to_s).include?("MongoMapper::Document")
        receiver.class_exec do
          include Amistad::MongoMapperFriendModel
          include Amistad::MongoFriendModel
        end
      else
        raise "Amistad only supports ActiveRecord, Mongoid and MongoMapper"
      end
    end
  end
end
