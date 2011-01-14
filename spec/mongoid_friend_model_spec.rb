require 'mongoid_spec_helper'

describe Amistad::Mongoid::FriendModel do
  def reset_friendships
    %w(john jane david james peter mary victoria elisabeth).each do |var|
      eval "@#{var}.delete_all_friendships.should be_true"
    end
  end
  
  before(:all) do
    Object.send(:remove_const, :User) if Object.const_defined?(:User)
    User = Class.new
    User.class_exec do
      include Mongoid::Document
      include Amistad::FriendModel
      field :name, :required => true
    end
  end
  
  it_should_behave_like "a friend model"
end
