require "spec_helper"
require 'mongoid'

Mongoid.configure do |config|
  config.connect_to  "amistad_mongoid_test"
end

RSpec.configure do |config|
  config.before(:each) do
    Mongoid.purge!
  end
end
