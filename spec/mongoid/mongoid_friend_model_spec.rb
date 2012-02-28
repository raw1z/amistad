require File.dirname(__FILE__) + '/mongoid_spec_helper'

describe Amistad::Mongoid::FriendModel do
  def reset_friendships
    %w(john jane david james peter mary victoria elisabeth).each do |var|
      eval "@#{var}.delete_all_friendships.should be_true"
    end
  end

  before(:all) do
    reload_environment

    User = Class.new
    User.class_exec do
      include Mongoid::Document
      field :name, :require => true
    end
  end

  it_should_behave_like "friend with parameterized models" do
    let(:friend_model_param) { User }
  end
end
