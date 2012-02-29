shared_examples_for "friend with parameterized models" do
  context "When users are created after activating amistad" do
    before(:each) do
      activate_amistad(friend_model_param)
      create_users(friend_model_param)
    end

    it_should_behave_like "a friend model"
  end

  context "When users are created before activating amistad" do
    before(:each) do
      create_users(friend_model_param)
      activate_amistad(friend_model_param)
    end

    it_should_behave_like "a friend model"
  end
end