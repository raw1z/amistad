require 'mongoid_spec_helper'

describe Amistad::Mongoid::FriendModel do
  def create_instance_variable(attributes)
    Member.create(attributes)
  end
  
  def reset_friendships
    %w(john jane david james peter mary victoria elisabeth).each do |var|
      eval "@#{var}.delete_all_friendships.should be_true"
    end
  end
  
  it_should_behave_like "a friend model"
end
