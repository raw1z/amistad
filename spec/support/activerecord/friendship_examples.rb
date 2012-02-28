shared_examples_for "the friendship model" do  
  it "should validate presence of the user's id and the friend's id" do
    friendship = Amistad.friendship_class.new
    friendship.valid?.should be_false
    friendship.errors.should include(:friendable_id)
    friendship.errors.should include(:friend_id)
    friendship.errors.size.should == 2
  end

  context "when creating friendship" do
    before do
      @jane.invite(@david)
      @friendship = Amistad.friendship_class.first
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
      @friendship.can_block?(@jane).should be_false
    end

    it "should not be available to unblock" do
      @friendship.can_unblock?(@jane).should be_false
      @friendship.can_unblock?(@david).should be_false
    end
  end

  context "when approving friendship" do
    before do
      @jane.invite(@david)
      @david.approve(@jane)
      @friendship = Amistad.friendship_class.first
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
      @friendship.can_block?(@jane).should be_true
      @friendship.can_block?(@david).should be_true
    end

    it "should not be availabel to unblock" do
      @friendship.can_unblock?(@jane).should be_false
      @friendship.can_unblock?(@david).should be_false
    end
  end

  context "when blocking friendship" do
    before do
      @jane.invite(@david)
      @david.block(@jane)
      @friendship = Amistad.friendship_class.first
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
      @friendship.can_block?(@jane).should be_false
      @friendship.can_block?(@david).should be_false
    end

    it "should be available to unblock only by user who blocked it" do
      @friendship.can_unblock?(@david).should be_true
      @friendship.can_unblock?(@jane).should be_false
    end
  end
end