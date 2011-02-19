require File.dirname(__FILE__) + "/activerecord_spec_helper"

describe Amistad::ActiveRecord::FriendModel do
  def reset_friendships
    Friendship.delete_all
  end
  
  before(:all) do
    create_users
  end
  
  it_should_behave_like "a friend model"
end
