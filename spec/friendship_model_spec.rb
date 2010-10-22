require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Amistad::FriendshipModel do
  
  before(:each) do
    Friendship.delete_all
  end
  
  it "validates presence of the user's id and the friend's id" do
    friendship = Friendship.new
    friendship.save.should == false
    
    friendship = Friendship.new(:user_id => 1, :friend_id => 2)
    friendship.save.should == true
  end
  
  it "is in pending state when created" do
    friendship = Friendship.create(:user_id => 1, :friend_id => 2)
    friendship.pending?.should == true
  end
  
  it "is not in a blocked state when created" do
    friendship = Friendship.create(:user_id => 1, :friend_id => 2)
    friendship.blocked?.should == false
  end
end