require File.dirname(__FILE__) + '/mongoid_spec_helper'

describe Amistad::Mongoid::FriendModel do
  def reset_friendships
    %w(john jane david james peter mary victoria elisabeth).each do |var|
      eval "@#{var}.delete_all_friendships.should be_true"
    end
  end

  context "When users are created after activating amistad" do
    before(:all) do
      # create a user model with amistad activated
      Object.send(:remove_const, :User) if Object.const_defined?(:User)
      User = Class.new
      User.class_exec do
        include Mongoid::Document
        include Amistad::FriendModel
        field :name, :require => true
      end
      
      # create the users
      create_users
    end
  
    it_should_behave_like "a friend model"
  end
  
  context "When users are created before activating amistad" do
    before(:all) do
      # create a user model without amistad activated
      Object.send(:remove_const, :User) if Object.const_defined?(:User)
      User = Class.new
      User.class_exec do
        include Mongoid::Document
        field :name, :require => true
      end
      
      # create the users
      create_users
      
      # activate amistad
      User.class_exec { include Amistad::FriendModel }
    end
  
    it_should_behave_like "a friend model"
  end
end
