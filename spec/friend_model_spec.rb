require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Amistad::FriendModel do
  
  before(:all) do
    %w(John Jane david James Peter Mary Victoria Elisabeth).each do |name|
      eval "@#{name.downcase} = User.create(:name => '#{name}')"
    end
  end
  
  context "when creating friendships" do
    before(:each) do
      Friendship.delete_all
    end
    
    it "requests frienships with other users" do
      @john.invite(@jane).should == true
      @victoria.invite(@john).should == true
    end

    it "approves frienships requested by other users" do
      @john.invite(@jane).should == true
      @victoria.invite(@john).should == true

      @jane.approve(@john).should == true
      @john.approve(@victoria).should == true
    end
    
    it "could not create a new friendship with a user which is already a friend" do
      @john.invite(@jane).should == true
      @john.invite(@jane).should == false
      @jane.invite(@john).should == false
    end
    
    it "could not create a friendship with himself" do
      @john.invite(@john).should == false
    end
    
    it "could not approuve a non-existent friendship" do
      @peter.approve(@john).should == false
    end
  end
  
  context "when listing friendships" do
    before(:each) do
      Friendship.delete_all
      @john.invite(@jane).should == true
      @john.invite(@james).should == true
      
      @peter.invite(@john).should == true
      @mary.invite(@john).should == true
      
      @james.approve(@john).should == true
      @john.approve(@mary).should == true
    end
    
    it "lists all the friends" do
      @john.friends.count.should == 2
      @john.friends.should include(@james)
      @john.friends.should include(@mary)
    end
    
    it "lists the friends who invited him" do
      @john.invited_by.should include(@mary)
      @john.invited_by.should_not include(@peter)
    end
    
    it "lists the friends who was invited by him" do
      @john.invited.should include(@james)
      @john.invited.should_not include(@jane)
    end
    
    it "lists the pending friends who invited him" do
      @john.pending_invited_by.should_not include(@mary)
      @john.pending_invited_by.should include(@peter)
    end

    it "lists the pending friends who was invited by him" do
      @john.pending_invited.should_not include(@james)
      @john.pending_invited.should include(@jane)
    end

    it "checks if a user is a friend" do
      @john.is_friend_with?(@james).should == true
      @john.is_friend_with?(@mary).should == true
      
      @john.is_friend_with?(@jane).should == false
      @john.is_friend_with?(@peter).should == false
    end
    
    it "lists the friends he has in common with another user" do
      @james.common_friends_with(@mary).count.should == 1
      @james.common_friends_with(@mary).should include(@john)
    end
  end
  
  context "when removing friendships" do
    before(:each) do
      Friendship.delete_all
      @victoria.invite(@mary).should == true
      @victoria.invite(@john).should == true
      @victoria.invite(@elisabeth).should == true
      
      @james.invite(@victoria).should == true
      @peter.invite(@victoria).should == true
      @jane.invite(@victoria).should == true
      
      @mary.approve(@victoria).should == true
      @john.approve(@victoria).should == true
      @victoria.approve(@james).should == true
      @victoria.approve(@jane).should == true
    end
    
    it "removes the friends invited by him" do
      @victoria.remove(@mary).should == true
      
      @victoria.invited.count.should == 1
      @victoria.invited.should include(@john)
      @victoria.friends.should_not include(@mary)
      
      @mary.invited_by.should_not include(@victoria)
      @mary.friends.should_not include(@victoria)
    end
    
    it "removes the friends who invited him" do
      @victoria.remove(@james).should == true
      
      @victoria.invited_by.count.should == 1
      @victoria.invited_by.should include(@jane)
      @victoria.friends.should_not include(@james)
      
      @james.invited.should_not include(@victoria)
      @james.friends.should_not include(@victoria)
    end
    
    it "removes the pending friends invited by him" do
      @victoria.remove(@elisabeth).should == true
      @victoria.pending_invited.count.should == 0
      @elisabeth.pending_invited_by.should_not include(@victoria)
    end
    
    it "removes the pending friends who invited him" do
      @victoria.remove(@peter).should == true
      @victoria.pending_invited_by.count.should == 0
      @peter.pending_invited.should_not include(@victoria)
    end
  end

end