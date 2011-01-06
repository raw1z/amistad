require 'spec_helper'

describe Amistad::FriendshipModel do

  before do
    Friendship.delete_all
  end

  context "when validating friendship" do
    it "should validate presence of the user's id and the friend's id" do
      friendship = Friendship.new
      friendship.valid?.should be_false
      friendship.errors.should include(:user_id)
      friendship.errors.should include(:friend_id)
      friendship = Friendship.new(:user_id => 1, :friend_id => 2)
      friendship.valid?.should be_true
      friendship.save.should be_true
    end
  end

  context "when creating friendship" do
    before do
      @friendship = Friendship.create(:user_id => 1, :friend_id => 2)
    end

    it "should be in pending state when created" do
      @friendship.pending?.should be_true
    end

    it "should not be in a blocked state when created" do
      @friendship.blocked?.should be_false
    end
  end
end
