require File.dirname(__FILE__) + '/mongo_mapper_spec_helper'

describe "The friend model" do
  before(:all) do
    reload_environment

    User = Class.new
    User.class_exec do
      include MongoMapper::Document
      key :name, String
    end
  end

  it_should_behave_like "friend with parameterized models" do
    let(:friend_model_param) { User }
  end
end
