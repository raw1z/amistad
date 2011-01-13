require 'activerecord_spec_helper'

describe Amistad::ActiveRecord::FriendModel do
  def reset_friendships
    Friendship.delete_all
  end
  
  it_should_behave_like "a friend model"
end
