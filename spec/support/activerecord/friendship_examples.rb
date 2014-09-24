shared_examples_for "the friendship model" do  
  it "should validate presence of the user's id and the friend's id" do
    friendship = Amistad.friendship_class.new
    expect(friendship.valid?).to eq(false)
    expect(friendship.errors).to include(:friendable_id)
    expect(friendship.errors).to include(:friend_id)
    expect(friendship.errors.size).to eq(2)
  end

  context "when creating friendship" do
    before do
      @jane.invite(@david)
      @friendship = Amistad.friendship_class.first
    end

    it "should be pending" do
      expect(@friendship.pending?).to eq(true)
    end

    it "should not be approved" do
      expect(@friendship.approved?).to eq(false)
    end

    it "should be active" do
      expect(@friendship.active?).to eq(true)
    end

    it "should not be blocked" do
      expect(@friendship.blocked?).to eq(false)
    end

    it "should be available to block only by invited user" do
      expect(@friendship.can_block?(@david)).to eq(true)
      expect(@friendship.can_block?(@jane)).to eq(false)
    end

    it "should not be available to unblock" do
      expect(@friendship.can_unblock?(@jane)).to eq(false)
      expect(@friendship.can_unblock?(@david)).to eq(false)
    end
  end

  context "when approving friendship" do
    before do
      @jane.invite(@david)
      @david.approve(@jane)
      @friendship = Amistad.friendship_class.first
    end

    it "should be approved" do
      expect(@friendship.approved?).to eq(true)
    end

    it "should not be pending" do
      expect(@friendship.pending?).to eq(false)
    end

    it "should be active" do
      expect(@friendship.active?).to eq(true)
    end

    it "should not be blocked" do
      expect(@friendship.blocked?).to eq(false)
    end

    it "should be available to block by both users" do
      expect(@friendship.can_block?(@jane)).to eq(true)
      expect(@friendship.can_block?(@david)).to eq(true)
    end

    it "should not be availabel to unblock" do
      expect(@friendship.can_unblock?(@jane)).to eq(false)
      expect(@friendship.can_unblock?(@david)).to eq(false)
    end
  end

  context "when blocking friendship" do
    before do
      @jane.invite(@david)
      @david.block(@jane)
      @friendship = Amistad.friendship_class.first
    end

    it "should not be approved" do
      expect(@friendship.approved?).to eq(false)
    end

    it "should be pending" do
      expect(@friendship.pending?).to eq(true)
    end

    it "should not be active" do
      expect(@friendship.active?).to eq(false)
    end

    it "should be blocked" do
      expect(@friendship.blocked?).to eq(true)
    end

    it "should not be available to block" do
      expect(@friendship.can_block?(@jane)).to eq(false)
      expect(@friendship.can_block?(@david)).to eq(false)
    end

    it "should be available to unblock only by user who blocked it" do
      expect(@friendship.can_unblock?(@david)).to eq(true)
      expect(@friendship.can_unblock?(@jane)).to eq(false)
    end
  end
end
