require File.dirname(__FILE__) + "/activerecord_spec_helper"

describe "The friend model" do
  before(:all) do
    reload_environment
    User = Class.new(ActiveRecord::Base)

  end

  it_should_behave_like "friend with parameterized models" do
    let(:friend_model_param) { User }
  end
end
