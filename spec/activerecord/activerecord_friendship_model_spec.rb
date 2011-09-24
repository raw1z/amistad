require File.dirname(__FILE__) + "/activerecord_spec_helper"

describe Amistad::ActiveRecord::FriendshipModel do

  before(:all) do
    %w(Jane David Bob).each do |name|
      instance_variable_set("@#{name.downcase}".to_sym, User.create(:name => name))
    end
  end

  context "when finding one user from another" do
    before do
      Friendship.delete_all
      @jane.invite(@david)
      @friendship = Friendship.first
    end

    it "should find the invited friend given the inviting friend" do
      @friendship.friend_with(@jane).should == @david
    end

    it "should find the inviting friend given the invited friend" do
      @friendship.friend_with(@david).should == @jane
    end

    it "should return nil if the friendship does not include the user" do
      @friendship.friend_with(@bob).should be_nil
    end
  end

  it "should validate presence of the user's id and the friend's id" do
    friendship = Friendship.new
    friendship.valid?.should be_false
    friendship.errors.should include(:user_id)
    friendship.errors.should include(:friend_id)
    friendship.errors.size.should == 2
  end

  context "when creating friendship" do
    before do
      Friendship.delete_all
      @jane.invite(@david)
      @friendship = Friendship.first
    end

    it "should be pending" do
      @friendship.pending?.should be_true
    end

    it "should not be approved" do
      @friendship.approved?.should be_false
    end

    it "should be active" do
      @friendship.active?.should be_true
    end

    it "should not be blocked" do
      @friendship.blocked?.should be_false
    end

    it "should be available to block only by invited user" do
      @friendship.can_block?(@david).should be_true
      @friendship.can_block?(@sane).should be_false
    end

    it "should not be availabel to unblock" do
      @friendship.can_unblock?(@jane).should be_false
      @friendship.can_unblock?(@david).should be_false
    end
  end

  context "when approving friendship" do
    before do
      Friendship.delete_all
      @jane.invite(@david)
      @david.approve(@jane)
      @friendship = Friendship.first
    end

    it "should be approved" do
      @friendship.approved?.should be_true
    end

    it "should not be pending" do
      @friendship.pending?.should be_false
    end

    it "should be active" do
      @friendship.active?.should be_true
    end

    it "should not be blocked" do
      @friendship.blocked?.should be_false
    end

    it "should be available to block by both users" do
      @friendship.can_block?(@sane).should be_true
      @friendship.can_block?(@david).should be_true
    end

    it "should not be availabel to unblock" do
      @friendship.can_unblock?(@jane).should be_false
      @friendship.can_unblock?(@david).should be_false
    end
  end

  context "when blocking friendship" do
    before do
      Friendship.delete_all
      @jane.invite(@david)
      @david.block(@jane)
      @friendship = Friendship.first
    end

    it "should not be approved" do
      @friendship.approved?.should be_false
    end

    it "should be pending" do
      @friendship.pending?.should be_true
    end

    it "should not be active" do
      @friendship.active?.should be_false
    end

    it "should be blocked" do
      @friendship.blocked?.should be_true
    end

    it "should not be available to block" do
      @friendship.can_block?(@sane).should be_false
      @friendship.can_block?(@david).should be_false
    end

    it "should be available to unblock only by user who blocked it" do
      @friendship.can_unblock?(@david).should be_true
      @friendship.can_unblock?(@jane).should be_false
    end
  end
end
