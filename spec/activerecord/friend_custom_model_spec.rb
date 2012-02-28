require File.dirname(__FILE__) + "/activerecord_spec_helper"

describe 'Custom friend model' do
  before(:all) do
    reload_environment

    Amistad.configure do |config|
      config.friend_model = 'Profile'
    end

    Profile = Class.new(ActiveRecord::Base)
  end

  it_should_behave_like "friend with parameterized models" do
    let(:friend_model_param) { Profile }
  end
end
