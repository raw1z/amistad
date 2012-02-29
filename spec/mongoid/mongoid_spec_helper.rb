require "spec_helper"
require 'mongoid'

Mongoid.configure do |config|
  name = "amistad_test"
  host = "localhost"
  config.master = Mongo::Connection.new.db(name)
end

RSpec.configure do |config|
  config.before(:each) do
    Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
end
