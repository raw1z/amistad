require File.dirname(__FILE__) + '/mongo_mapper_spec_helper'

describe 'Custom friend model' do
  def reset_friendships
    %w(john jane david james peter mary victoria elisabeth).each do |var|
      eval "@#{var}.delete_all_friendships.should be_true"
    end
  end

  before(:all) do
    reload_environment

    Amistad.configure do |config|
      config.friend_model = 'Profile'
    end

    Profile = Class.new
    Profile.class_exec do
      include MongoMapper::Document
      key :name, String
    end
  end

  it_should_behave_like "friend with parameterized models" do
    let(:friend_model_param) { Profile }
  end
end
