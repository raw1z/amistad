require "spec_helper"
require 'mongoid'

Mongoid.configure do |config|
  name = "amistad_test"
  host = "localhost"
  config.master = Mongo::Connection.new.db(name)
  config.slaves = [
    Mongo::Connection.new(host, 27017, :slave_ok => true).db(name)
  ]
end
