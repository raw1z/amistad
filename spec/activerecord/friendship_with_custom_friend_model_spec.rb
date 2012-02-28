require File.dirname(__FILE__) + "/activerecord_spec_helper"

describe 'Amistad friendship model whith custom friend model' do

  before(:all) do
    reload_environment

    Amistad.configure do |config|
      config.friend_model = 'Profile'
    end

    Profile = Class.new(ActiveRecord::Base)
    activate_amistad(Profile)
    create_users(Profile)
  end

  it_should_behave_like "the friendship model"
end
