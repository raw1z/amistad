require 'activerecord_spec_helper'

describe Amistad::ActiveRecord::FriendModel do
  def create_instance_variable(attributes)
    User.create(attributes)
  end
  
  def reset_friendships
    Friendship.delete_all
  end
  
  it_should_behave_like "a friend model"
end
