shared_examples_for "a friend model" do
  context "when creating friendships" do
    it "should invite other users to friends" do
      expect(@john.invite(@jane)).to eq(true)
      expect(@victoria.invite(@john)).to eq(true)
    end

    it "should approve only friendships requested by other users" do
      expect(@john.invite(@jane)).to eq(true)
      expect(@jane.approve(@john)).to eq(true)
      expect(@victoria.invite(@john)).to eq(true)
      expect(@john.approve(@victoria)).to eq(true)
    end

    it "should not invite an already invited user" do
      expect(@john.invite(@jane)).to eq(true)
      expect(@john.invite(@jane)).to eq(false)
      expect(@jane.invite(@john)).to eq(false)
    end

    it "should not invite an already approved user" do
      expect(@john.invite(@jane)).to eq(true)
      expect(@jane.approve(@john)).to eq(true)
      expect(@jane.invite(@john)).to eq(false)
      expect(@john.invite(@jane)).to eq(false)
    end

    it "should not invite an already blocked user" do
      expect(@john.invite(@jane)).to eq(true)
      expect(@jane.block(@john)).to eq(true)
      expect(@jane.invite(@john)).to eq(false)
      expect(@john.invite(@jane)).to eq(false)
    end

    it "should not approve a self requested friendship" do
      expect(@john.invite(@jane)).to eq(true)
      expect(@john.approve(@jane)).to eq(false)
      expect(@victoria.invite(@john)).to eq(true)
      expect(@victoria.approve(@john)).to eq(false)
    end

    it "should not create a friendship with himself" do
      expect(@john.invite(@john)).to eq(false)
    end

    it "should not approve a non-existent friendship" do
      expect(@peter.approve(@john)).to eq(false)
    end
  end

  context "when listing friendships" do
    before(:each) do
      expect(@john.invite(@jane)).to eq(true)
      expect(@peter.invite(@john)).to eq(true)
      expect(@john.invite(@james)).to eq(true)
      expect(@james.approve(@john)).to eq(true)
      expect(@mary.invite(@john)).to eq(true)
      expect(@john.approve(@mary)).to eq(true)
    end

    it "should list all the friends" do
      expect(@john.friends).to match_array([@mary, @james])
    end

    it "should not list non-friended users" do
      expect(@victoria.friends).to be_empty
      expect(@john.friends).to match_array([@mary, @james])
      expect(@john.friends).to_not include(@peter)
      expect(@john.friends).to_not include(@victoria)
    end

    it "should list the friends who invited him" do
      expect(@john.invited_by).to eq([@mary])
    end

    it "should list the friends who were invited by him" do
      expect(@john.invited).to eq([@james])
    end

    it "should list the pending friends who invited him" do
      expect(@john.pending_invited_by).to eq([@peter])
    end

    it "should list the pending friends who were invited by him" do
      expect(@john.pending_invited).to eq([@jane])
    end

    it "should list the friends he has in common with another user" do
      expect(@james.common_friends_with(@mary)).to eq([@john])
    end

    it "should not list the friends he does not have in common" do
      expect(@john.common_friends_with(@mary).count).to eq(0)
      expect(@john.common_friends_with(@mary)).to_not include(@james)
      expect(@john.common_friends_with(@peter).count).to eq(0)
      expect(@john.common_friends_with(@peter)).to_not include(@jane)
    end

    it "should check if a user is a friend" do
      expect(@john.friend_with?(@mary)).to eq(true)
      expect(@mary.friend_with?(@john)).to eq(true)
      expect(@john.friend_with?(@james)).to eq(true)
      expect(@james.friend_with?(@john)).to eq(true)
    end

    it "should check if a user is not a friend" do
      expect(@john.friend_with?(@jane)).to eq(false)
      expect(@jane.friend_with?(@john)).to eq(false)
      expect(@john.friend_with?(@peter)).to eq(false)
      expect(@peter.friend_with?(@john)).to eq(false)
    end

    it "should check if a user has any connections with another user" do
      expect(@john.connected_with?(@jane)).to eq(true)
      expect(@jane.connected_with?(@john)).to eq(true)
      expect(@john.connected_with?(@peter)).to eq(true)
      expect(@peter.connected_with?(@john)).to eq(true)
    end

    it "should check if a user does not have any connections with another user" do
      expect(@victoria.connected_with?(@john)).to eq(false)
      expect(@john.connected_with?(@victoria)).to eq(false)
    end

    it "should check if a user was invited by another" do
      expect(@jane.invited_by?(@john)).to eq(true)
      expect(@james.invited_by?(@john)).to eq(true)
    end

    it "should check if a user was not invited by another" do
      expect(@john.invited_by?(@jane)).to eq(false)
      expect(@victoria.invited_by?(@john)).to eq(false)
    end

    it "should check if a user has invited another user" do
      expect(@john.invited?(@jane)).to eq(true)
      expect(@john.invited?(@james)).to eq(true)
    end

    it "should check if a user did not invite another user" do
      expect(@jane.invited?(@john)).to eq(false)
      expect(@james.invited?(@john)).to eq(false)
      expect(@john.invited?(@victoria)).to eq(false)
      expect(@victoria.invited?(@john)).to eq(false)
    end
  end

  context "when removing friendships" do
    before(:each) do
      expect(@jane.invite(@james)).to eq(true)
      expect(@james.approve(@jane)).to eq(true)
      expect(@james.invite(@victoria)).to eq(true)
      expect(@victoria.approve(@james)).to eq(true)
      expect(@victoria.invite(@mary)).to eq(true)
      expect(@mary.approve(@victoria)).to eq(true)
      expect(@victoria.invite(@john)).to eq(true)
      expect(@john.approve(@victoria)).to eq(true)
      expect(@peter.invite(@victoria)).to eq(true)
      expect(@victoria.invite(@elisabeth)).to eq(true)
    end

    it "should remove the friends invited by him" do
      expect(@victoria.friends.size).to eq(3)
      expect(@victoria.friends).to include(@mary)
      expect(@victoria.invited).to include(@mary)
      expect(@mary.friends.size).to eq(1)
      expect(@mary.friends).to include(@victoria)
      expect(@mary.invited_by).to include(@victoria)

      expect(@victoria.remove_friendship(@mary)).to eq(true)
      expect(@victoria.friends.size).to eq(2)
      expect(@victoria.friends).to_not include(@mary)
      expect(@victoria.invited).to_not include(@mary)
      expect(@mary.friends.size).to eq(0)
      expect(@mary.friends).to_not include(@victoria)
      expect(@mary.invited_by).to_not include(@victoria)
    end

    it "should remove the friends who invited him" do
      expect(@victoria.friends.size).to eq(3)
      expect(@victoria.friends).to include(@james)
      expect(@victoria.invited_by).to include(@james)
      expect(@james.friends.size).to eq(2)
      expect(@james.friends).to include(@victoria)
      expect(@james.invited).to include(@victoria)

      expect(@victoria.remove_friendship(@james)).to eq(true)
      expect(@victoria.friends.size).to eq(2)
      expect(@victoria.friends).to_not include(@james)
      expect(@victoria.invited_by).to_not include(@james)
      expect(@james.friends.size).to eq(1)
      expect(@james.friends).to_not include(@victoria)
      expect(@james.invited).to_not include(@victoria)
    end

    it "should remove the pending friends invited by him" do
      expect(@victoria.pending_invited.size).to eq(1)
      expect(@victoria.pending_invited).to include(@elisabeth)
      expect(@elisabeth.pending_invited_by.size).to eq(1)
      expect(@elisabeth.pending_invited_by).to include(@victoria)
      expect(@victoria.remove_friendship(@elisabeth)).to eq(true)
      [@victoria, @elisabeth].map(&:reload)
      expect(@victoria.pending_invited.size).to eq(0)
      expect(@victoria.pending_invited).to_not include(@elisabeth)
      expect(@elisabeth.pending_invited_by.size).to eq(0)
      expect(@elisabeth.pending_invited_by).to_not include(@victoria)
    end

    it "should remove the pending friends who invited him" do
      expect(@victoria.pending_invited_by.count).to eq(1)
      expect(@victoria.pending_invited_by).to include(@peter)
      expect(@peter.pending_invited.count).to eq(1)
      expect(@peter.pending_invited).to include(@victoria)
      expect(@victoria.remove_friendship(@peter)).to eq(true)
      [@victoria, @peter].map(&:reload)
      expect(@victoria.pending_invited_by.count).to eq(0)
      expect(@victoria.pending_invited_by).to_not include(@peter)
      expect(@peter.pending_invited.count).to eq(0)
      expect(@peter.pending_invited).to_not include(@victoria)
    end
  end

  context "when blocking friendships" do
    before(:each) do
      expect(@john.invite(@james)).to eq(true)
      expect(@james.approve(@john)).to eq(true)
      expect(@james.block(@john)).to eq(true)
      expect(@mary.invite(@victoria)).to eq(true)
      expect(@victoria.approve(@mary)).to eq(true)
      expect(@victoria.block(@mary)).to eq(true)
      expect(@victoria.invite(@david)).to eq(true)
      expect(@david.block(@victoria)).to eq(true)
      expect(@john.invite(@david)).to eq(true)
      expect(@david.block(@john)).to eq(true)
      expect(@peter.invite(@elisabeth)).to eq(true)
      expect(@elisabeth.block(@peter)).to eq(true)
      expect(@jane.invite(@john)).to eq(true)
      expect(@jane.invite(@james)).to eq(true)
      expect(@james.approve(@jane)).to eq(true)
      expect(@victoria.invite(@jane)).to eq(true)
      expect(@victoria.invite(@james)).to eq(true)
      expect(@james.approve(@victoria)).to eq(true)
    end

    it "should allow to block author of the invitation by invited user" do
      expect(@john.block(@jane)).to eq(true)
      expect(@jane.block(@victoria)).to eq(true)
    end

    it "should not allow to block invited user by invitation author" do
      expect(@jane.block(@john)).to eq(false)
      expect(@victoria.block(@jane)).to eq(false)
    end

    it "should allow to block approved users on both sides" do
      expect(@james.block(@jane)).to eq(true)
      expect(@victoria.block(@james)).to eq(true)
    end

    it "should not allow to block not connected user" do
      expect(@david.block(@peter)).to eq(false)
      expect(@peter.block(@david)).to eq(false)
    end

    it "should not allow to block already blocked user" do
      expect(@john.block(@jane)).to eq(true)
      expect(@john.block(@jane)).to eq(false)
      expect(@james.block(@jane)).to eq(true)
      expect(@james.block(@jane)).to eq(false)
    end

    it "should list the blocked users" do
      expect(@jane.blocked).to be_empty
      expect(@peter.blocked).to be_empty
      expect(@james.blocked).to eq([@john])
      expect(@victoria.blocked).to eq([@mary])
      expect(@david.blocked).to match_array([@john, @victoria])
    end

    it "should not list blocked users in friends" do
      expect(@james.friends).to match_array([@jane, @victoria])
      @james.blocked.each do |user|
        expect(@james.friends).to_not include(user)
        expect(user.friends).to_not include(@james)
      end
    end

    it "should not list blocked users in invited" do
      expect(@victoria.invited).to eq([@james])
      @victoria.blocked.each do |user|
        expect(@victoria.invited).to_not include(user)
        expect(user.invited_by).to_not include(@victoria)
      end
    end

    it "should not list blocked users in invited pending by" do
      expect(@david.pending_invited_by).to be_empty
      @david.blocked.each do |user|
        expect(@david.pending_invited_by).to_not include(user)
        expect(user.pending_invited).to_not include(@david)
      end
    end

    it "should check if a user is blocked" do
      expect(@james.blocked?(@john)).to eq(true)
      expect(@victoria.blocked?(@mary)).to eq(true)
      expect(@david.blocked?(@john)).to eq(true)
      expect(@david.blocked?(@victoria)).to eq(true)
    end
  end

  context "when unblocking friendships" do
    before(:each) do
      expect(@john.invite(@james)).to eq(true)
      expect(@james.approve(@john)).to eq(true)
      expect(@john.block(@james)).to eq(true)
      expect(@john.unblock(@james)).to eq(true)
      expect(@mary.invite(@victoria)).to eq(true)
      expect(@victoria.approve(@mary)).to eq(true)
      expect(@victoria.block(@mary)).to eq(true)
      expect(@victoria.unblock(@mary)).to eq(true)
      expect(@victoria.invite(@david)).to eq(true)
      expect(@david.block(@victoria)).to eq(true)
      expect(@david.unblock(@victoria)).to eq(true)
      expect(@john.invite(@david)).to eq(true)
      expect(@david.block(@john)).to eq(true)
      expect(@peter.invite(@elisabeth)).to eq(true)
      expect(@elisabeth.block(@peter)).to eq(true)
      expect(@jane.invite(@john)).to eq(true)
      expect(@jane.invite(@james)).to eq(true)
      expect(@james.approve(@jane)).to eq(true)
      expect(@victoria.invite(@jane)).to eq(true)
      expect(@victoria.invite(@james)).to eq(true)
      expect(@james.approve(@victoria)).to eq(true)
    end

    it "should allow to unblock prevoiusly blocked user" do
      expect(@david.unblock(@john)).to eq(true)
      expect(@elisabeth.unblock(@peter)).to eq(true)
    end

    it "should not allow to unblock not prevoiusly blocked user" do
      expect(@john.unblock(@jane)).to eq(false)
      expect(@james.unblock(@jane)).to eq(false)
      expect(@victoria.unblock(@jane)).to eq(false)
      expect(@james.unblock(@victoria)).to eq(false)
    end

    it "should not allow to unblock blocked user by himself" do
      expect(@john.unblock(@david)).to eq(false)
      expect(@peter.unblock(@elisabeth)).to eq(false)
    end

    it "should list unblocked users in friends" do
      expect(@john.friends).to eq([@james])
      expect(@mary.friends).to eq([@victoria])
      expect(@victoria.friends).to match_array([@mary, @james])
      expect(@james.friends).to match_array([@john, @jane, @victoria])
    end

    it "should list unblocked users in invited" do
      expect(@john.invited).to eq([@james])
      expect(@mary.invited).to eq([@victoria])
    end

    it "should list unblocked users in invited by" do
      expect(@victoria.invited_by).to eq([@mary])
      expect(@james.invited_by).to match_array([@john, @jane, @victoria])
    end

    it "should list unblocked users in pending invited" do
      expect(@victoria.pending_invited).to match_array([@jane, @david])
    end

    it "should list unblocked users in pending invited by" do
      expect(@david.pending_invited_by).to eq([@victoria])
    end
  end

  context "when counting friendships and blocks" do
    before do
      expect(@john.invite(@james)).to eq(true)
      expect(@james.approve(@john)).to eq(true)
      expect(@john.invite(@victoria)).to eq(true)
      expect(@victoria.approve(@john)).to eq(true)
      expect(@elisabeth.invite(@john)).to eq(true)
      expect(@john.approve(@elisabeth)).to eq(true)

      expect(@victoria.invite(@david)).to eq(true)
      expect(@david.block(@victoria)).to eq(true)
      expect(@mary.invite(@victoria)).to eq(true)
      expect(@victoria.block(@mary)).to eq(true)
    end

    it "should return the correct count for total_friends" do
      expect(@john.total_friends).to eq(3)
      expect(@elisabeth.total_friends).to eq(1)
      expect(@james.total_friends).to eq(1)
      expect(@victoria.total_friends).to eq(1)
    end

    it "should return the correct count for total_blocked" do
      expect(@david.total_blocked).to eq(1)
      expect(@victoria.total_blocked).to eq(1)
    end
  end
end
